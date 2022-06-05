import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:fashion_customer/model/order_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generatePdf(OrderModel orderModel) async {
  pw.Document doc = pw.Document();

  String orderState() {
    switch (orderModel.orderState) {
      case OrderState.placed:
        return 'Order Placed';
      case OrderState.confirmed:
        return 'Order Confirmed';
      case OrderState.outForDelivery:
        return 'Out for Delivery';
      case OrderState.delivered:
        return 'Delivered';
      case OrderState.cancel:
        return 'Order Cancelled';

      default:
        return 'Order Placed';
    }
  }

  pw.BoxDecoration defContainerDec = pw.BoxDecoration(
    color: pdf.PdfColors.white,
    border: pw.Border.all(
        color: pdf.PdfColor.fromInt(KConstants.kBorderColor.value)),
  );

  pdf.PdfColor getStateColor() {
    switch (orderModel.orderState) {
      case OrderState.placed:
      case OrderState.confirmed:
      case OrderState.outForDelivery:
      case OrderState.delivered:
        return pdf.PdfColor.fromInt(KConstants.greenOrderState.value);
      case OrderState.cancel:
        return pdf.PdfColors.red;
      default:
        return pdf.PdfColor.fromInt(KConstants.greenOrderState.value);
    }
  }

  List<Uint8List> prodImages = [];

  for (var i = 0; i < orderModel.products.length; i++) {
    Response response =
        await get(Uri.parse(orderModel.products[i].image.first));
    prodImages.add(response.bodyBytes);
  }

  pdf.PdfColor kPrimary = pdf.PdfColor.fromInt(KConstants.kPrimary100.value);
  pdf.PdfColor textColor50 = pdf.PdfColor.fromInt(KConstants.textColor50.value);
  pdf.PdfColor C8D5EF = pdf.PdfColor.fromInt(0xffC8D5EF);

  var page = pw.MultiPage(

    margin: pw.EdgeInsets.all(5),
    pageFormat: pdf.PdfPageFormat.a4,
    build: (context) {
      return [
        pw.Wrap(
          children: [
            pw.Container(
              width: double.infinity,
              decoration: defContainerDec,
              padding: pw.EdgeInsets.all(16),
              child: pw.Text(
                'FASHEO ORDER INVOICE INV${orderModel.orderId}',
                textScaleFactor: 1.1,
              ),
            ),
            pw.Container(
              decoration: defContainerDec,
              padding: pw.EdgeInsets.all(16),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Order ID ${orderModel.orderId}',
                      textScaleFactor: 1.1),
                  pw.Text(
                    DateFormat('hh:mm a, dd MMMM, yyyy')
                        .format(orderModel.createdAt.toDate()),
                    style: pw.TextStyle(color: textColor50),
                  ),
                ],
              ),
            ),
            ...orderModel.products.mapIndexed((index, e) {
              return pw.Container(
                padding: pw.EdgeInsets.all(16.0),
                height: 150,
                margin: pw.EdgeInsets.only(bottom: 4),
                decoration: pw.BoxDecoration(
                  color: pdf.PdfColors.white,
                  border: pw.Border.all(
                    color: C8D5EF,
                  ),
                ),
                child: pw.Row(
                  children: [
                    pw.Container(
                      height: 120,
                      width: 160,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: C8D5EF,
                        ),
                      ),
                      child: pw.Image(
                        pw.MemoryImage(
                          prodImages[index],
                        ),
                        height: 120,
                        width: 160,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                    pw.SizedBox(
                      width: 8.0,
                    ),
                    pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          orderModel.products[index].name,
                          style: pw.TextStyle(fontSize: 18),
                        ),
                        pw.SizedBox(
                          height: 4.0,
                        ),
                        pw.Text(
                          "Price: ${orderModel.products[index].price}",
                          style: pw.TextStyle(
                              color: pdf.PdfColor.fromInt(0xff604FCC),
                              fontWeight: pw.FontWeight.bold),
                        ),
                        if (orderModel.products[index].selectedSize != '') ...[
                          pw.SizedBox(
                            height: 4.0,
                          ),
                          pw.Text(
                            "Selected Size: ${orderModel.products[index].selectedSize}",
                            style: pw.TextStyle(
                                color: pdf.PdfColor.fromInt(0xff604FCC),
                                fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                        pw.SizedBox(
                          height: 4,
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              "Selected Colour:",
                              style: pw.TextStyle(
                                  color: pdf.PdfColor.fromInt(
                                      Color(0xff604FCC).value),
                                  fontWeight: pw.FontWeight.bold),
                            ),
                            pw.SizedBox(
                              width: 10,
                            ),
                            pw.Container(
                              decoration: pw.BoxDecoration(
                                  color: pdf.PdfColor.fromInt(
                                      orderModel.products[index].color),
                                  borderRadius: pw.BorderRadius.circular(10)),
                              height: 20,
                              width: 30,
                            )
                          ],
                        ),
                        pw.SizedBox(
                          height: 4,
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              "Selected Quantity: ${e.quantity}",
                              style: pw.TextStyle(
                                  color: pdf.PdfColor.fromInt(
                                      Color(0xff604FCC).value),
                                  fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
            pw.Container(
              padding: pw.EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: pdf.PdfColor.fromInt(0xffC7D4EE),
                ),
                color: pdf.PdfColors.white,
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Text(
                        'Deliver to',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Spacer(),
                    ],
                  ),
                  pw.SizedBox(
                    height: 8.0,
                  ),
                  pw.Text(
                    orderModel.address.actualAddress,
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: pdf.PdfColors.black,
                    ),
                  )
                ],
              ),
            ),
            pw.SizedBox(
              height: 4.0,
            ),
            pw.Container(
              width: double.infinity,
              padding: pw.EdgeInsets.all(16.0),
              decoration: pw.BoxDecoration(
                color: pdf.PdfColors.white,
                border: pw.Border.all(
                  color: pdf.PdfColor.fromInt(0xffC7D4EE),
                ),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    'Order Summary',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: pdf.PdfColor.fromInt(0xff130B43),
                    ),
                  ),
                  pw.SizedBox(
                    height: 8.0,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        'Subtotal',
                        style: pw.TextStyle(
                          fontSize: 14.0,
                          color: pdf.PdfColor.fromInt(0xff130B43),
                        ),
                      ),
                      pw.Spacer(),
                      pw.Text(
                        orderModel.totalPrice.toString(),
                        style: pw.TextStyle(
                          fontSize: 14.0,
                          color: pdf.PdfColor.fromInt(0xff130B43),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 4.0,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        'Delivery Charges',
                        style: pw.TextStyle(
                          fontSize: 14.0,
                          color: pdf.PdfColor.fromInt(0xff130B43),
                        ),
                      ),
                      pw.Spacer(),
                      pw.Text(
                        'Free',
                        style: pw.TextStyle(
                          fontSize: 14.0,
                          color: pdf.PdfColor.fromInt(0xff130B43),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 4.0,
                  ),
                  if (orderModel.couponModel != null) ...[
                    pw.Row(
                      children: [
                        pw.Text(
                          'Discount',
                          style: pw.TextStyle(
                            fontSize: 14.0,
                            color: pdf.PdfColor.fromInt(0xff130B43),
                          ),
                        ),
                        pw.Spacer(),
                        pw.Text(
                          (orderModel.totalDiscountPrice).toString(),
                          style: pw.TextStyle(
                            fontSize: 14.0,
                            color: pdf.PdfColor.fromInt(0xff130B43),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      height: 4.0,
                    ),
                  ],
                  pw.Row(
                    children: [
                      pw.Text(
                        'Total',
                        style: pw.TextStyle(
                          fontSize: 16.0,
                          color: pdf.PdfColor.fromInt(0xff130B43),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Spacer(),
                      pw.Text(
                        (orderModel.totalPrice - orderModel.totalDiscountPrice)
                            .toString(),
                        style: pw.TextStyle(
                          fontSize: 16.0,
                          color: pdf.PdfColor.fromInt(0xff130B43),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (orderModel.couponModel != null) ...[
              pw.SizedBox(
                height: 4,
              ),
              pw.Container(
                decoration: defContainerDec,
                width: double.infinity,
                padding: pw.EdgeInsets.all(16.0),
                child: pw.Row(
                  children: [
                    pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Coupon Applied',
                            style: pw.TextStyle(color: kPrimary)),
                        pw.Text(orderModel.couponModel!.couponCode,
                            style: pw.TextStyle(color: kPrimary)),
                      ],
                    ),
                    pw.Spacer(),
                    pw.Icon(
                      pw.IconData(Icons.check.codePoint),
                      color: kPrimary,
                    ),
                  ],
                ),
              ),
            ],
            pw.SizedBox(
              height: 4,
            ),
            pw.Container(
              decoration: defContainerDec,
              padding: pw.EdgeInsets.all(16),
              width: double.infinity,
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    orderState(),
                    style: pw.TextStyle(color: getStateColor()),
                  ),
                  pw.SizedBox(
                    height: 7,
                  ),
                  if ([OrderState.confirmed, OrderState.outForDelivery]
                      .contains(orderModel.orderState))
                    pw.Text(
                      'Expected Delivery by: ' +
                          DateFormat((orderModel.orderState ==
                                          OrderState.outForDelivery
                                      ? 'hh:mm a,'
                                      : '') +
                                  'dd MMMM, yyyy')
                              .format(orderModel.deliveryDate.toDate()),
                      style: pw.TextStyle(color: textColor50),
                    )
                  else if (orderModel.orderState == OrderState.delivered)
                    pw.Text(
                        'Delivered on: ' +
                            DateFormat('hh:mm a, dd MMMM, yyyy')
                                .format(orderModel.deliveredDate.toDate()),
                        style: pw.TextStyle(color: textColor50)),
                ],
              ),
            ),
            if (orderModel.orderState == OrderState.cancel)
              pw.Container(
                width: double.infinity,
                margin: pw.EdgeInsets.only(top: 7),
                padding: pw.EdgeInsets.all(16.0),
                decoration: defContainerDec,
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Cancellation Details',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: pdf.PdfColor.fromInt(0xff130B43),
                      ),
                    ),
                    pw.SizedBox(
                      height: 8.0,
                    ),
                    pw.Text(
                      'Cancelled By: ${orderModel.cancelledByUser ? 'You' : 'Admin'}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: pdf.PdfColors.black,
                      ),
                    ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    pw.Text(
                      'Reason: ${orderModel.cancellationReason}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: pdf.PdfColors.black,
                      ),
                    ),
                  ],
                ),
              )
          ],
        )
      ];
    },
  );

  doc.addPage(page);

  return await doc.save();
}
