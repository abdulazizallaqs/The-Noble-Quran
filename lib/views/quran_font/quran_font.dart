import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hafzon/core/color_manager.dart';
import 'package:hafzon/core/helper_methods.dart';
import 'package:hafzon/provider/settings_provider.dart';
import 'package:hafzon/views/nav_bar/view.dart';

class QuranFont extends StatefulWidget {
  const QuranFont({super.key});

  @override
  State<QuranFont> createState() => _QuranFontState();
}

class _QuranFontState extends State<QuranFont> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          leading:
              BackButton(color: Theme.of(context).textTheme.bodyLarge?.color),
          elevation: 0.0,
          title: Text(
            "الخط",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                        style: TextStyle(
                            fontFamily: settings.arabicFont,
                            fontSize: settings.arabicFontSize),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Slider(
                        value: settings.arabicFontSize,
                        activeColor: ColorManager.orangeColor,
                        inactiveColor:
                            ColorManager.orangeColor.withOpacity(0.5),
                        min: 20,
                        max: 40,
                        onChanged: (value) {
                          settings.setArabicFontSize(value);
                        },
                      ),
                      const SizedBox(height: 20),
                      SwitchListTile(
                        title: Text(
                          'وضع القراءة كصفحات',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 18,
                          ),
                        ),
                        activeColor: ColorManager.orangeColor,
                        value: settings.isPageView,
                        onChanged: (value) {
                          settings.setPageView(value);
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          'تذكير يومي', // Daily Reminder
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: const Text(
                            'احصل على تذكير لقراءة الورد'), // Get notified to read
                        activeColor: ColorManager.orangeColor,
                        value: settings.isDailyReminderEnabled,
                        onChanged: (value) {
                          settings.toggleDailyReminder(value);
                        },
                      ),
                      if (settings.isDailyReminderEnabled)
                        ListTile(
                          title: Text(
                            'وقت التذكير: ${settings.reminderTime.format(context)}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(Icons.access_time),
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: settings.reminderTime,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Color(
                                          0xffF26872), // Use lightMain or a solid color
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(
                                            0xffF26872), // Ensure buttons are visible
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              settings.setReminderTime(picked);
                            }
                          },
                        ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.orangeColor,
                              elevation: 0.0,
                            ),
                            onPressed: () {
                              settings.resetSettings();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'إعادة ضبط',
                                style: TextStyle(
                                    color: ColorManager.white, fontSize: 20),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.orangeColor,
                              elevation: 0.0,
                            ),
                            onPressed: () {
                              navigateTo(
                                  page: const NavBarView(), withHistory: false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'يحفظ',
                                style: TextStyle(
                                    color: ColorManager.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
