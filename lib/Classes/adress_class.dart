class Address {
  String complex;
  String buildingNumber;
  String floor;
  String room;

  Address(
      {required this.complex,
      required this.buildingNumber,
      required this.floor,
      required this.room});

  Address.late({
    this.complex='',
    this.buildingNumber='',
    this.floor='',
    this.room='',
});

  factory Address.fromMap(Map<String, dynamic> address) {
    return Address(
        complex: address['Complex'],
        buildingNumber: address['Building Number'],
        floor: address['Floor'],
        room: address['Room']);
  }

  void fromMap(Map<String, dynamic> address) {
    complex = address['Complex'];
    buildingNumber = address['Building Number'];
    floor = address['Floor'];
    room = address['Room'];
  }

  Map<String, dynamic> toMap(){
    return{
      'Building Number': buildingNumber,
      'Floor': floor,
      'Room': room,
      'Complex': complex,
    };
  }
}
