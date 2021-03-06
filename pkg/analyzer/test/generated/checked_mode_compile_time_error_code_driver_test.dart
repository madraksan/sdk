// Copyright (c) 2016, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/src/error/codes.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'checked_mode_compile_time_error_code.dart';
import 'resolver_test_case.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(CheckedModeCompileTimeErrorCodeTest_Driver);
    defineReflectiveTests(SetElementTypeNotAssignableTest);
    defineReflectiveTests(SetElementTypeNotAssignableWithCodeAsUITest);
  });
}

@reflectiveTest
class CheckedModeCompileTimeErrorCodeTest_Driver
    extends CheckedModeCompileTimeErrorCodeTest {
  @override
  bool get enableNewAnalysisDriver => true;
}

@reflectiveTest
class SetElementTypeNotAssignableTest extends ResolverTestCase {
  @override
  bool get enableNewAnalysisDriver => true;

  test_simple() async {
    Source source = addSource("var v = const <String>{42};");
    await computeAnalysisResult(source);
    // TODO(brianwilkerson) Fix this so that only one error is produced.
    assertErrors(source, [
      CheckedModeCompileTimeErrorCode.SET_ELEMENT_TYPE_NOT_ASSIGNABLE,
      StaticWarningCode.SET_ELEMENT_TYPE_NOT_ASSIGNABLE
    ]);
    verify([source]);
  }
}

@reflectiveTest
class SetElementTypeNotAssignableWithCodeAsUITest extends ResolverTestCase {
  @override
  List<String> get enabledExperiments => ['spread-collections'];

  @override
  bool get enableNewAnalysisDriver => true;

  test_simple_const() async {
    // TODO(brianwilkerson) This test is not dependent on the experiments and
    //  should be moved when these tests are cleaned up.
    Source source = addSource("var v = const <String>{42};");
    await computeAnalysisResult(source);
    assertErrors(source,
        [CheckedModeCompileTimeErrorCode.SET_ELEMENT_TYPE_NOT_ASSIGNABLE]);
    verify([source]);
  }

  test_simple_nonConst() async {
    // TODO(brianwilkerson) This test is not dependent on the experiments and
    //  should be moved when these tests are cleaned up.
    Source source = addSource("var v = <String>{42};");
    await computeAnalysisResult(source);
    assertErrors(source, [StaticWarningCode.SET_ELEMENT_TYPE_NOT_ASSIGNABLE]);
    verify([source]);
  }

  test_spread_valid_const() async {
    await assertNoErrorsInCode('''
var v = const <String>{...['a', 'b']};
''');
  }

  test_spread_valid_nonConst() async {
    await assertNoErrorsInCode('''
var v = <String>{...['a', 'b']};
''');
  }
}
