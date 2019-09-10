function deprecated::compatible_default(
  Any $deprecated_parameter_value,
  Any $parameter_default,
) {
  $deprecated_parameter_value ? {
    Deprecated::Param => $parameter_default,
    default           => $deprecated_parameter_value,
  }
}
