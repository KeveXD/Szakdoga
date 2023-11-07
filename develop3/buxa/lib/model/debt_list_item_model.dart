import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DebtListItemModel {
  final DebtRepository _debtRepository = DebtRepository();

  Future<String> getDebtorName(int debtorPersonId) async {
    if (kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final userEmail = user.email;

        final peopleCollectionRef = firestore
            .collection(userEmail!)
            .doc('userData')
            .collection('People');

        final debtorPersonSnapshot = await peopleCollectionRef
            .where('id', isEqualTo: debtorPersonId)
            .get();

        if (debtorPersonSnapshot.docs.isNotEmpty) {
          final debtorPersonData =
              debtorPersonSnapshot.docs.first.data() as Map<String, dynamic>;
          final debtorPersonName = debtorPersonData['name'] as String;
          return debtorPersonName;
        }
      }
      return 'N/A';
    } else {
      final debtorPerson =
          await PersonRepository().getPersonById(debtorPersonId);
      return debtorPerson?.name ?? 'N/A';
    }
  }

  Future<String> getPersonToName(int personToId) async {
    if (kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final userEmail = user.email;

        final peopleCollectionRef = firestore
            .collection(userEmail!)
            .doc('userData')
            .collection('People');

        final personToSnapshot =
            await peopleCollectionRef.where('id', isEqualTo: personToId).get();

        if (personToSnapshot.docs.isNotEmpty) {
          final personToData =
              personToSnapshot.docs.first.data() as Map<String, dynamic>;
          final personToName = personToData['name'] as String;
          return personToName;
        }
      }
      return 'N/A';
    } else {
      final personTo = await PersonRepository().getPersonById(personToId);
      return personTo?.name ?? 'N/A';
    }
  }
}
