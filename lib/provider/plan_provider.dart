import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hafzon/model/plan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanProvider extends ChangeNotifier {
  List<PlanModel> _plans = [];
  List<PlanModel> get plans => _plans;

  PlanProvider() {
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final String? plansJson = prefs.getString('user_plans');
    if (plansJson != null) {
      final List<dynamic> decoded = json.decode(plansJson);
      _plans = decoded.map((e) => PlanModel.fromMap(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _savePlans() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_plans.map((e) => e.toMap()).toList());
    await prefs.setString('user_plans', encoded);
  }

  void addPlan(PlanModel plan) {
    _plans.add(plan);
    _savePlans();
    notifyListeners();
  }

  void removePlan(String id) {
    _plans.removeWhere((element) => element.id == id);
    _savePlans();
    notifyListeners();
  }

  void updatePlan(PlanModel plan) {
    final index = _plans.indexWhere((element) => element.id == plan.id);
    if (index != -1) {
      _plans[index] = plan;
      _savePlans();
      notifyListeners();
    }
  }

  void toggleComplete(String id) {
    final index = _plans.indexWhere((element) => element.id == id);
    if (index != -1) {
      _plans[index].isCompleted = !_plans[index].isCompleted;
      _savePlans();
      notifyListeners();
    }
  }
}
