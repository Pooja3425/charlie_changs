class Order_Detail_Response {
  String status;
  Data data;

  Order_Detail_Response({this.status, this.data});

  Order_Detail_Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String paymentStatus;
  String orderid;
  String ordercode;
  String discount;
  String deliveryCharge;
  String totalAmount;
  String isOnlinePaid;
  String deliveryDate;
  String deliveryTime;
  String orderDateTime;
  String firstName;
  String lastName;
  String email;
  String mobile;
  String address1;
  String address2;
  String addressName;
  Null pincode;
  Null landmark;
  Null delNote;
  String restname;
  String custArea;
  String cityname;
  String restArea;
  Null cseName;
  List<OrderItems> orderItems;

  Data(
      {this.paymentStatus,
        this.orderid,
        this.ordercode,
        this.discount,
        this.deliveryCharge,
        this.totalAmount,
        this.isOnlinePaid,
        this.deliveryDate,
        this.deliveryTime,
        this.orderDateTime,
        this.firstName,
        this.lastName,
        this.email,
        this.mobile,
        this.address1,
        this.address2,
        this.addressName,
        this.pincode,
        this.landmark,
        this.delNote,
        this.restname,
        this.custArea,
        this.cityname,
        this.restArea,
        this.cseName,
        this.orderItems});

  Data.fromJson(Map<String, dynamic> json) {
    paymentStatus = json['payment_status'];
    orderid = json['orderid'];
    ordercode = json['ordercode'];
    discount = json['discount'];
    deliveryCharge = json['delivery_charge'];
    totalAmount = json['total_amount'];
    isOnlinePaid = json['is_online_paid'];
    deliveryDate = json['delivery_date'];
    deliveryTime = json['delivery_time'];
    orderDateTime = json['order_date_time'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    address1 = json['address1'];
    address2 = json['address2'];
    addressName = json['address_name'];
    pincode = json['pincode'];
    landmark = json['landmark'];
    delNote = json['del_note'];
    restname = json['restname'];
    custArea = json['cust_area'];
    cityname = json['cityname'];
    restArea = json['rest_area'];
    cseName = json['cse_name'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_status'] = this.paymentStatus;
    data['orderid'] = this.orderid;
    data['ordercode'] = this.ordercode;
    data['discount'] = this.discount;
    data['delivery_charge'] = this.deliveryCharge;
    data['total_amount'] = this.totalAmount;
    data['is_online_paid'] = this.isOnlinePaid;
    data['delivery_date'] = this.deliveryDate;
    data['delivery_time'] = this.deliveryTime;
    data['order_date_time'] = this.orderDateTime;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['address_name'] = this.addressName;
    data['pincode'] = this.pincode;
    data['landmark'] = this.landmark;
    data['del_note'] = this.delNote;
    data['restname'] = this.restname;
    data['cust_area'] = this.custArea;
    data['cityname'] = this.cityname;
    data['rest_area'] = this.restArea;
    data['cse_name'] = this.cseName;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  String orderid;
  String itemId;
  String itemName;
  String quantity;
  String tax;
  String price;
  String itemTotal;

  OrderItems(
      {this.orderid,
        this.itemId,
        this.itemName,
        this.quantity,
        this.tax,
        this.price,
        this.itemTotal});

  OrderItems.fromJson(Map<String, dynamic> json) {
    orderid = json['orderid'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    quantity = json['quantity'];
    tax = json['tax'];
    price = json['price'];
    itemTotal = json['item_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderid'] = this.orderid;
    data['item_id'] = this.itemId;
    data['item_name'] = this.itemName;
    data['quantity'] = this.quantity;
    data['tax'] = this.tax;
    data['price'] = this.price;
    data['item_total'] = this.itemTotal;
    return data;
  }
}
