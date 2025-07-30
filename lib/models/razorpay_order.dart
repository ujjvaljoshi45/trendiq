class RazorpayOrder {
  RazorpayOrder({
    required this.amount,
    required this.amountDue,
    required this.amountPaid,
    required this.attempts,
    required this.createdAt,
    required this.currency,
    required this.entity,
    required this.id,
    required this.notes,
    required this.offerId,
    required this.receipt,
    required this.status,
  });

  final int? amount;
  final int? amountDue;
  final int? amountPaid;
  final int? attempts;
  final int? createdAt;
  final String? currency;
  final String? entity;
  final String? id;
  final Map<String, dynamic>? notes;
  final dynamic offerId;
  final String? receipt;
  final String? status;

  factory RazorpayOrder.fromJson(Map<String, dynamic> json) {
    return RazorpayOrder(
      amount: json["amount"],
      amountDue: json["amount_due"],
      amountPaid: json["amount_paid"],
      attempts: json["attempts"],
      createdAt: json["created_at"],
      currency: json["currency"],
      entity: json["entity"],
      id: json["id"],
      notes: json["notes"],
      offerId: json["offer_id"],
      receipt: json["receipt"],
      status: json["status"],
    );
  }
}
