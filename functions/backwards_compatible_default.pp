function deprecated::backwards_compatible_default(
  Any $deprecated_parameter_value,
  Any $default,
) {
  $deprecated_parameter_value ? {
    Deprecated::Param => $default,
    default           => $deprecated_parameter_value,
  }
}
