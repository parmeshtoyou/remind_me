import 'package:flutter/widgets.dart';

class PersonBuilder {

  late Person _person;

  PersonBuilder createPerson() {
    _person = Person();
    return this;
  }

  PersonBuilder setName(String name) {
    _person.name = name;
    return this;
  }

  PersonBuilder setAge(int age) {
    _person.age = age;
    return this;
  }

  PersonBuilder setAddress(String address) {
    _person.address = address;
    return this;
  }

  Person build() {
    return _person;
  }
}

class Person {
  late String _name;
  late int _age;
  late String _address;

  Person() : super();

  int get age => _age;

  set age(int value) {
    _age = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  @override
  String toString() {
    return 'Person{_name: $_name, _age: $_age, _address: $_address}';
  }
}

main() {
  var person = PersonBuilder()
      .createPerson()
      .setName("Parmesh")
      .setAddress("Bangalore")
      .setAge(35).build();

  print(person);
}
