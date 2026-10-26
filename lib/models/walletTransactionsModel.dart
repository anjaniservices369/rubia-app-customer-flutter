// =============================================================================
// WHAT : Data shape of the wallet transaction list returned by the server.
// NOTES: Used by the wallet screens.
// =============================================================================
// To parse this JSON data, do
//
//     final walletTransactionModel = walletTransactionModelFromJson(jsonString);

import 'dart:convert';

WalletTransactionModel walletTransactionModelFromJson(String str) => WalletTransactionModel.fromJson(json.decode(str));

String walletTransactionModelToJson(WalletTransactionModel data) => json.encode(data.toJson());

// >>> START: WalletTransactionModel - helper class
class WalletTransactionModel {
    String status;
    String url;
    List<Detail> details;

    WalletTransactionModel({
        required this.status,
        required this.url,
        required this.details,
    });

    factory WalletTransactionModel.fromJson(Map<String, dynamic> json) => WalletTransactionModel(
        status: json["status"],
        url: json["url"],
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    );

    // >>> START: toJson - turns this object into the form the server expects
    Map<String, dynamic> toJson() => {
        "status": status,
        "url": url,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
    };
    // <<< END: toJson - turns this object into the form the server expects
}
// <<< END: WalletTransactionModel - helper class

// >>> START: Detail - helper class
class Detail {
    int id;
    int userId;
    String amount;
    int paymentType;
    dynamic methodReason;
    int status;
    DateTime createdOn;
    DateTime updatedOn;
    int createUserId;
    int updateUserId;

    Detail({
        required this.id,
        required this.userId,
        required this.amount,
        required this.paymentType,
        required this.methodReason,
        required this.status,
        required this.createdOn,
        required this.updatedOn,
        required this.createUserId,
        required this.updateUserId,
    });

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        userId: json["user_id"],
        amount: json["amount"],
        paymentType: json["payment_type"],
        methodReason: json["method_reason"]!,
        status: json["status"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        createUserId: json["create_user_id"],
        updateUserId: json["update_user_id"],
    );

    // >>> START: toJson - turns this object into the form the server expects
    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "amount": amount,
        "payment_type": paymentType,
        "method_reason":methodReason,
        "status": status,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "create_user_id": createUserId,
        "update_user_id": updateUserId,
    };
    // <<< END: toJson - turns this object into the form the server expects
}
// <<< END: Detail - helper class


