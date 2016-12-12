Geocoder.configure(lookup: :test)

# Bulldog Northeast
Geocoder::Lookup::Test.add_stub(
 '401 E Hennepin Ave, Minneapolis, MN 55414', [{
    'latitude' => 44.988829,
    'longitude' => -93.254953
  }]
)
# Mac's Industrial
Geocoder::Lookup::Test.add_stub(
 '312 Central Ave SE, Minneapolis, MN 55414', [{
    'latitude' => 44.986861,
    'longitude' => -93.254333
  }]
)
# Muddy Waters
Geocoder::Lookup::Test.add_stub(
 '2933 Lyndale Ave S, Minneapolis, MN 55408', [{
    'latitude' => 44.949225,
    'longitude' => -93.287703
  }]
)
# Groveland Tap
Geocoder::Lookup::Test.add_stub(
 '1834 St Clair Ave, St Paul, MN 55105', [{
    'latitude' => 44.934076,
    'longitude' => -93.177874
  }]
)
# Edina Grill
Geocoder::Lookup::Test.add_stub(
 '5028 France Ave S, Edina, MN 55424', [{
    'latitude' => 44.911701,
    'longitude' => -93.329416
  }]
)
# Happy Gnome
Geocoder::Lookup::Test.add_stub(
 '498 Selby Ave, St Paul, MN 55102', [{
    'latitude' => 44.946357,
    'longitude' => -93.121018
  }]
)
# Buster's on 28th
Geocoder::Lookup::Test.add_stub(
 '4204 S 28th Ave, Minneapolis, MN 55406', [{
    'latitude' => 44.926635,
    'longitude' => -93.232429
  }]
)
# Ginger Hop
Geocoder::Lookup::Test.add_stub(
 '201 E Hennepin Ave,  Minneapolis, MN 55414', [{
    'latitude' => 44.987718,
    'longitude' => -93.257658
  }]
)
Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)
__END__
 id |       name        | latitude  | longitude
----+-------------------+-----------+------------
  1 | Bulldog Northeast | 44.988829 | -93.254953
  2 | Macs Industrial   | 44.986861 | -93.254333
  3 | Muddy Waters      | 44.949225 | -93.287703
  4 | Groveland Tap     | 44.934076 | -93.177874
  5 | Edina Grill       | 44.911701 | -93.329416
  6 | Happy Gnome       | 44.946357 | -93.121018
  7 | Busters On 28th   | 44.926635 | -93.232429
  8 | Ginger Hop        | 44.987718 | -93.257658
