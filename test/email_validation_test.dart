import 'package:flutter_test/flutter_test.dart';
import 'package:klikit/app/functions.dart';

void main(){
  test('All email should be valid',(){
    expect(isEmailValid('example@email.com'), true);
    expect(isEmailValid('example.first.middle.lastname@email.com'), true);
    expect(isEmailValid('example@subdomain.email.com'), true);
    expect(isEmailValid('example+firstname+lastname@email.com'), true);
    //expect(isEmailValid('example@234.234.234.234'), true);
    expect(isEmailValid('example@[234.234.234.234]'), true);
    expect(isEmailValid('“example”@email.com'), true);
    expect(isEmailValid('0987654321@example.com'), true);
    expect(isEmailValid('example@email-one.com'), true);
    expect(isEmailValid('_______@email.com'), true);
    expect(isEmailValid('example@email.name'), true);
    expect(isEmailValid('example@email.museum'), true);
    expect(isEmailValid('example@email.co.jp'), true);
    expect(isEmailValid('example.firstname-lastname@email.com'), true);
    expect(isEmailValid('extremely.”odd\'unusual”@example.com'), true);
    expect(isEmailValid('extremely@example-exe.com'), true);
    //expect(isEmailValid('extremely.unusual.”@”.unusual.com@example.com'), true);
    //expect(isEmailValid('very.”(),:;<>[]”.VERY.”very@\\ “very”.unusual@strange.email.example.com'), true);
  });
}