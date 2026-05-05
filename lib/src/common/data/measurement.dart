import 'package:flutter/material.dart';

import '../extension/context_x.dart';

class MeasurementData {
  static Map<String, List<String>> measurements(BuildContext context) => {
    // QUANTITY
    context.s.category_quantity: [
      context.s.unit_each,
      context.s.unit_piece,
      context.s.unit_set,
      context.s.unit_sheet,
      context.s.unit_item,
      context.s.unit_pair,
      context.s.unit_dozen,
    ],

    // LENGTH
    context.s.category_length: [
      context.s.unit_mm,
      context.s.unit_cm,
      context.s.unit_m,
      context.s.unit_km,
      context.s.unit_inch,
      context.s.unit_foot,
      context.s.unit_yard,
      context.s.unit_mile,
    ],

    // AREA
    context.s.category_area: [
      context.s.unit_m2,
      context.s.unit_ft2,
      context.s.unit_yd2,
      context.s.unit_hectare,
      context.s.unit_acre,
    ],

    // VOLUME
    context.s.category_volume: [
      context.s.unit_ml,
      context.s.unit_l,
      context.s.unit_m3,
      context.s.unit_ft3,
      context.s.unit_yd3,
      context.s.unit_gallon,
      context.s.unit_quart,
    ],

    // WEIGHT
    context.s.category_weight: [
      context.s.unit_g,
      context.s.unit_kg,
      context.s.unit_lb,
      context.s.unit_ton,
    ],

    // TIME
    context.s.category_time: [
      context.s.unit_second,
      context.s.unit_minute,
      context.s.unit_hour,
      context.s.unit_man_hour,
      context.s.unit_day,
      context.s.unit_week,
      context.s.unit_month,
      context.s.unit_year,
    ],

    // BULK & PACKAGED
    context.s.category_bulk_packaged: [
      context.s.unit_bag,
      context.s.unit_box,
      context.s.unit_bundle,
      context.s.unit_roll,
      context.s.unit_package,
      context.s.unit_pallet,
      context.s.unit_container,
      context.s.unit_truckload,
    ],
  };
}
