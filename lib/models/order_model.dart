import 'dart:convert';

class OrderModel {
    final bool? success;
    final String? message;
    final Data? data;

    OrderModel({
        this.success,
        this.message,
        this.data,
    });

    factory OrderModel.fromRawJson(String str) => OrderModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final int? id;
    final int? customerId;
    final String? provinceName;
    final String? cityName;
    final String? districtName;
    final String? subdistrictName;
    final int? zipCode;
    final String? fullAddress;
    final String? invoice;
    final int? weight;
    final String? total;
    final String? status;
    final String? snapToken;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Data({
        this.id,
        this.customerId,
        this.provinceName,
        this.cityName,
        this.districtName,
        this.subdistrictName,
        this.zipCode,
        this.fullAddress,
        this.invoice,
        this.weight,
        this.total,
        this.status,
        this.snapToken,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        customerId: json["customer_id"],
        provinceName: json["province_name"],
        cityName: json["city_name"],
        districtName: json["district_name"],
        subdistrictName: json["subdistrict_name"],
        zipCode: json["zip_code"],
        fullAddress: json["full_address"],
        invoice: json["invoice"],
        weight: json["weight"],
        total: json["total"],
        status: json["status"],
        snapToken: json["snap_token"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "province_name": provinceName,
        "city_name": cityName,
        "district_name": districtName,
        "subdistrict_name": subdistrictName,
        "zip_code": zipCode,
        "full_address": fullAddress,
        "invoice": invoice,
        "weight": weight,
        "total": total,
        "status": status,
        "snap_token": snapToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
