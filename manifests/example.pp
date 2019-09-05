class deprecated::example (
  Variant[String, Deprecated::Param] $api_v1 = deprecated::param(),
  String $api_v2 = deprecated::backwards_compatible_default($api_v1, 'api_v2 default')
) {
  deprecated::parameters({
    'api_v1' => { replacement => 'api_v2' },
  })

  notify { 'example':
    message => $api_v2,
  }
}
