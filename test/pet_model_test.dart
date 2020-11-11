import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:petshop_app/datas/pet_data.dart';
import 'package:petshop_app/model/pet_model.dart';

class MockPet extends Mock implements PetModel {
  List<PetData> pet = [];
}

class MockFirestore extends Mock implements Firestore {}

class MockPetData extends Mock implements PetData {
  String nome = "James";
  String raca = "Boxer";
  String sexo = "Macho";
  String tamanho = "Grande";
}

void main() {
  final mockPet = MockPet();
  final mockPetData = MockPetData();
  List<PetData> pet = [];

  setUp(() {});

  test("Verificando se a lista de Pets está vazia", () {
    List<PetData> pet = [];
    expect(pet.length, 0);
  });

  test("Adicionando um Pet", () {
    mockPet.addPet(mockPetData);
    mockPet.pet.add(mockPetData);
    // print(mockPet.pet.length);
    // print(mockPetData.nome);
    expect(mockPetData, mockPetData);
  });

  test("Removendo um Pet", () {
    mockPet.pet.add(mockPetData);
    // print(pet.length);
    mockPet.pet.remove(mockPetData);
    // print(pet.length);
  });
}
