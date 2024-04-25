import 'dart:ffi';

class Transaction {
  final Int id;
  final String label;
  final String details;
  final String document_id;
  final String accounting_date;
  final String user_id;
  final String share_id;
  final Int quantity;
  final Int unit_price;
  final Int total;
  final String transaction_type;
  final Int section_id;
  final Int exercice_id;
  final Bool validated;
  final String service_dates;

  Transaction(this.label, this.details, this.document_id, this.accounting_date, this.user_id, this.share_id, this.quantity, this.unit_price, this.total, this.transaction_type, this.section_id, this.exercice_id, this.validated, this.service_dates, this.id);
}