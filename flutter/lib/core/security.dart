import 'config.dart';

/// Device integrity verdict — mirrors the Expo hardening layer: release builds
/// refuse ROOTED/HOOKED/DEBUGGED, and pinning fails closed when required but
/// unconfigured. Jail-monkey/jailbreak detection is wired at the platform layer
/// (android); this is the pure policy so it is unit-testable.
enum SecurityReason { rooted, hooked, debugger, pinningMissing }

class SecurityVerdict {
  SecurityVerdict({required this.secure, this.reason});
  final bool secure;
  final SecurityReason? reason;
}

SecurityVerdict securityVerdict({
  required bool rooted,
  required bool hooked,
  required bool debuggerAttached,
  required bool releaseBuild,
  List<String>? pins,
  bool? requirePinning,
}) {
  final effectivePins = pins ?? Config.sslPins;
  final effectiveRequirePinning = requirePinning ?? Config.requirePinning;
<<<<<<< HEAD
  // Root/jailbreak/refurbished guards removed: the app must run on the
  // devices our drivers actually use, including refurbished and rooted ones.
=======
<<<<<<< HEAD
  if (releaseBuild && rooted) return SecurityVerdict(secure: false, reason: SecurityReason.rooted);
  if (releaseBuild && hooked) return SecurityVerdict(secure: false, reason: SecurityReason.hooked);
  if (releaseBuild && debuggerAttached) {
    return SecurityVerdict(secure: false, reason: SecurityReason.debugger);
  }
=======
  // Root/jailbreak/refurbished guards removed: the app must run on the
  // devices our drivers actually use, including refurbished and rooted ones.
>>>>>>> b798013 (Update: remove root/jailbreak guards + demo credentials)
>>>>>>> 683e824 (fix: resolve merge conflict in flutter.yml (keep secrets env blocks))
  if (effectiveRequirePinning && effectivePins.length < 2) {
    return SecurityVerdict(secure: false, reason: SecurityReason.pinningMissing);
  }
  return SecurityVerdict(secure: true);
}
