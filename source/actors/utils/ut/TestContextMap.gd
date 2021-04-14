extends "res://addons/gut/test.gd"

func before_all() -> void:
   gut.p("Runs once before all tests.")

func before_each() -> void:
   gut.p("Runs before each test.")

func after_each() -> void:
   gut.p("Runs after each test.")

func beforafter_alle_all() -> void:
   gut.p("Runs once after all tests.")

func test_assert_eq_number_not_equal() -> void:
   assert_eq(1, 2, "Should fail.  1 != 2")

