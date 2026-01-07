class Church {
  final String id;
  String name;
  String? locationLink;
  String? establishmentDate;
  String? dateCreated;
  String? dateUpdated;
  String? headOfficeId;

  Church({
    required this.id,
    required this.name,
    this.locationLink,
    this.establishmentDate,
    this.dateCreated,
    this.dateUpdated,
    this.headOfficeId,
  });

  factory Church.fromJson(Map<String, dynamic> json) {
    return Church(
      id: json['id'] as String,
      name: json['name'] as String,
      locationLink: json['locationLink'] as String?,
      establishmentDate: json['establishmentDate'] as String?,
      dateCreated: json['dateCreated'] as String?,
      dateUpdated: json['dateUpdated'] as String?,
      headOfficeId: json['headOfficeId'] as String?,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      if (locationLink != null) 'locationLink': locationLink,
      if (establishmentDate != null) 'establishmentDate': establishmentDate,
      'Head_office': headOfficeId,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      if (locationLink != null) 'locationLink': locationLink,
      if (establishmentDate != null) 'establishmentDate': establishmentDate,
    };
  }
}
