import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hafzon/core/color_manager.dart';
import 'package:hafzon/model/plan_model.dart';
import 'package:hafzon/provider/plan_provider.dart';
import 'package:hafzon/views/constant/constants.dart';

class PlanView extends StatefulWidget {
  const PlanView({super.key});

  @override
  State<PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الخطة',
          style: TextStyle(
            color: Color(0xffee8f8b),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Consumer<PlanProvider>(
        builder: (context, provider, child) {
          if (provider.plans.isEmpty) {
            return Center(
              child: Text(
                'لا توجد خطط بعد. ابدأ واحدة!',
                style: TextStyle(
                  color: ColorManager.grey,
                  fontSize: 18,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.plans.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final plan = provider.plans[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: plan.type == PlanType.reading
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.green.withOpacity(0.2),
                    child: Icon(
                      plan.type == PlanType.reading
                          ? Icons.menu_book
                          : Icons.psychology,
                      color: plan.type == PlanType.reading
                          ? Colors.blue
                          : Colors.green,
                    ),
                  ),
                  title: Text(
                    'السورة ${plan.targetSurahName}',
                    style: TextStyle(
                      decoration:
                          plan.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(plan.note),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: plan.isCompleted,
                        activeColor: ColorManager.orangeColor,
                        onChanged: (val) {
                          provider.toggleComplete(plan.id);
                        },
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showAddOrEditPlanDialog(context, plan: plan);
                          } else if (value == 'delete') {
                            _confirmDelete(context, provider, plan.id);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('تعديل'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('حذف'),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOrEditPlanDialog(context);
        },
        backgroundColor: ColorManager.orangeColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PlanProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الخطة'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذه الخطة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              provider.removePlan(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف الخطة')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddOrEditPlanDialog(BuildContext context, {PlanModel? plan}) {
    bool isEditing = plan != null;
    PlanType selectedType = plan?.type ?? PlanType.reading;
    String selectedSurahName = plan?.targetSurahName ??
        (arabicName.isNotEmpty ? arabicName[0]['name'] : 'Al-Fatiha');
    int selectedSurahIndex = plan?.targetSurahIndex ?? 0;

    final noteController = TextEditingController(text: plan?.note ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'تعديل الخطة' : 'خطة جديدة'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Type Selector
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<PlanType>(
                            title: const Text('قراءة'),
                            value: PlanType.reading,
                            groupValue: selectedType,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              setState(() => selectedType = val!);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<PlanType>(
                            title: const Text('حفظ'),
                            value: PlanType.memorizing,
                            groupValue: selectedType,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              setState(() => selectedType = val!);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Surah Dropdown
                    DropdownButtonFormField<int>(
                      value: selectedSurahIndex,
                      decoration:
                          const InputDecoration(labelText: 'السورة المستهدفة'),
                      items: List.generate(arabicName.length, (index) {
                        return DropdownMenuItem(
                          value: index,
                          child: Text(
                            "${index + 1}. ${arabicName[index]['name']}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                      onChanged: (val) {
                        setState(() {
                          selectedSurahIndex = val!;
                          selectedSurahName = arabicName[val]['name'];
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    // Note Field
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: 'ملاحظة / التكرار',
                        hintText: 'مثال: كل جمعة',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isEditing) {
                      final updatedPlan = PlanModel(
                        id: plan.id,
                        type: selectedType,
                        targetSurahName: selectedSurahName,
                        targetSurahIndex: selectedSurahIndex,
                        note: noteController.text,
                        isCompleted: plan.isCompleted,
                      );
                      context.read<PlanProvider>().updatePlan(updatedPlan);
                    } else {
                      final newPlan = PlanModel(
                        id: DateTime.now().toString(),
                        type: selectedType,
                        targetSurahName: selectedSurahName,
                        targetSurahIndex: selectedSurahIndex,
                        note: noteController.text,
                        isCompleted: false,
                      );
                      context.read<PlanProvider>().addPlan(newPlan);
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.orangeColor,
                  ),
                  child: Text(isEditing ? 'حفظ' : 'إضافة'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
