import 'package:flutter/material.dart';

class AddressData {
  final String id;
  final String label;
  final IconData icon;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final double lat;
  final double lng;

  const AddressData({
    required this.id,
    required this.label,
    required this.icon,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.lat,
    required this.lng,
  });

  AddressData copyWith({
    String? id,
    String? label,
    IconData? icon,
    String? name,
    String? phone,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    double? lat,
    double? lng,
  }) {
    return AddressData(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}
