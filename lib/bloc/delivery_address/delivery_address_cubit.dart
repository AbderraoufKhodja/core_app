import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/delivery_address.dart';

part 'delivery_address_state.dart';

class DeliveryAddressCubit extends Cubit<DeliveryAddressState> {
  final String userID;
  late Stream<QuerySnapshot<DeliveryAddress>> addresses;
  late final CollectionReference<DeliveryAddress> _delAddsRef;

  DeliveryAddressCubit({required this.userID})
      : _delAddsRef = DeliveryAddress.ref(userID: userID),
        addresses = DeliveryAddress.ref(userID: userID).snapshots(),
        super(DeliveryAddressDisplay());

  showDisplayPage() => emit(DeliveryAddressDisplay());
  showEditPage({required DeliveryAddress address}) => emit(
        DeliveryAddressEdit(address: address),
      );
  showAddPage() => emit(DeliveryAddressAdd());

  Stream<QuerySnapshot<DeliveryAddress>> getDeliveryAddress() {
    return _delAddsRef.snapshots();
  }

  Future<void> addDeliveryAddress({required DeliveryAddress address}) {
    final id = _delAddsRef.doc().id;
    address.id = id;
    return _delAddsRef.doc(id).set(address).then(
      (value) {
        AppUser.ref.doc(userID).update({AULabels.deliveryAddress.name: address.toFirestore()});
      },
    );
  }

  deleteDeliveryAddress({required DeliveryAddress address}) {
    //TODO implement delete address.
  }

  Future<void> updateDeliveryAddress({required DeliveryAddress address}) {
    return _delAddsRef.doc(address.id).update(address.toFirestore()).then((value) {
      AppUser.ref.doc(userID).update({AULabels.deliveryAddress.name: address.toFirestore()});
    });
  }
}
