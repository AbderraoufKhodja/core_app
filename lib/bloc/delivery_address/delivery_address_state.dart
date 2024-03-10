part of 'delivery_address_cubit.dart';

abstract class DeliveryAddressState extends Equatable {
  const DeliveryAddressState();

  @override
  List<Object> get props => [];
}

class DeliveryAddressDisplay extends DeliveryAddressState {}

class DeliveryAddressAdd extends DeliveryAddressState {}

class DeliveryAddressEdit extends DeliveryAddressState {
  final DeliveryAddress address;

  const DeliveryAddressEdit({required this.address});

  @override
  List<Object> get props => [address];
}
