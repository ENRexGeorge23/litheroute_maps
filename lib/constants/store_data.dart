import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

List<Map> stores = [
  {
    'id': '1',
    'name': 'ABY Construction Supply',
    'items': 'Construction Materials, Hardware, Plumbing, Electrical',
    'image': 'https://api.time.com/wp-content/uploads/2016/04/starbucks.jpeg',
    'coordinates': {
      'longitude': '123.94820269623392',
      'latitude': '10.253163766176812',
    },
  },
  {
    'id': '2',
    'name': 'Rosekie Drug Store',
    'items': 'Medicines, Vitamins, Supplements, Cosmetics, Toiletries',
    'image':
        'https://image.cnbcfm.com/api/v1/image/106334183-1578943648578gettyimages-526250086.jpeg?v=1578943742&w=1600&h=900',
    'coordinates': {
      'longitude': '123.94961291471611',
      'latitude': '10.252745383528477',
    },
  },
  {
    'id': '3',
    'name': 'Julies Bakeshop',
    'items': 'Bread, Pastries, Snacks',
    'image':
        'https://indiaeducationdiary.in/wp-content/uploads/2020/10/IMG-20201024-WA0014.jpg',
    'coordinates': {
      'longitude': '123.9493031084881',
      'latitude': '10.25239625690999',
    },
  },
  {
    'id': '4',
    'name': 'Gaisano Grand Mall',
    'items': 'Department Store, Groceries, Restaurants',
    'image':
        'https://10619-2.s.cdn12.com/rests/small/w550/h367/103_510330142.jpg',
    'coordinates': {
      'longitude': '123.9480532366764',
      'latitude': '10.257515820140142',
    },
  },
  {
    'id': '5',
    'name': 'Petron Gasoline Station',
    'items': 'Gasoline, Diesel, Convenience Store',
    'image':
        'https://10619-2.s.cdn12.com/rests/small/w550/h367/103_510330142.jpg',
    'coordinates': {
      'longitude': '123.94590375435985',
      'latitude': '10.27154329085',
    },
  },
  {
    'id': '6',
    'name': 'Gabi Construction Supply',
    'items': 'Sand, Gravel, Construction',
    'image':
        'https://10619-2.s.cdn12.com/rests/small/w550/h367/103_510330142.jpg',
    'coordinates': {
      'longitude': '123.95711725948075',
      'latitude': '10.259081442129414',
    },
  },
  {
    'id': '7',
    'name': 'Agila Resort',
    'items': 'Resort, Swimming Pool, Restaurant',
    'image':
        'https://10619-2.s.cdn12.com/rests/small/w550/h367/103_510330142.jpg',
    'coordinates': {
      'longitude': '123.96374903995525',
      'latitude': '10.25757143846',
    },
  },
  {
    'id': '8',
    'name': 'ACC Barber Shop',
    'items': 'Hairstyling, Haircut, Salon, Barber',
    'image':
        'https://10619-2.s.cdn12.com/rests/small/w550/h367/103_510330142.jpg',
    'coordinates': {
      'longitude': '123.95481600018917',
      'latitude': '10.270485812868444',
    },
  },
];

List<Position> storePositions = stores.map((store) {
  double longitude = double.parse(store['coordinates']['longitude']);
  double latitude = double.parse(store['coordinates']['latitude']);
  return Position(longitude, latitude);
}).toList();
