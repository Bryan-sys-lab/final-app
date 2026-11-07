import 'package:flutter_test/flutter_test.dart';
import 'package:helix/core/security.dart';
import 'package:helix/core/deep_links.dart';

void main() {
  test('release builds no longer block rooted or jailbroken devices', () {
    expect(securityVerdict(rooted: true, hooked: false, debuggerAttached: false, releaseBuild: true, requirePinning: false).secure, isTrue);
    expect(securityVerdict(rooted: false, hooked: true, debuggerAttached: false, releaseBuild: true, requirePinning: false).secure, isTrue);
    expect(securityVerdict(rooted: false, hooked: false, debuggerAttached: true, releaseBuild: true, requirePinning: false).secure, isTrue);
  });

  test('debug builds tolerate root and pinning fails closed when required', () {
    expect(
      securityVerdict(
        rooted: true,
        hooked: true,
        debuggerAttached: true,
        releaseBuild: false,
        requirePinning: false,
      ).secure,
      isTrue,
      reason: 'a debug build tolerates a rooted device',
    );
    expect(
      securityVerdict(
        rooted: false,
        hooked: false,
        debuggerAttached: false,
        releaseBuild: false,
        requirePinning: true,
        pins: const [],
      ).secure,
      isFalse,
      reason: 'pinning fails closed even in a debug build when it is required',
    );
    expect(
      securityVerdict(rooted: false, hooked: false, debuggerAttached: false, releaseBuild: true, requirePinning: true, pins: ['one-hash']).secure,
      isFalse,
    );
    expect(
      securityVerdict(rooted: false, hooked: false, debuggerAttached: false, releaseBuild: true, requirePinning: false, pins: ['a', 'b']).secure,
      isTrue,
    );
  });

  test('deep links validate scheme, ids and keys', () {
    final ok = parseDeepLink('helix://accident/123e4567-e89b-12d3-a456-426614174000');
    expect(ok!.kind, DeepLinkKind.accident);
    expect(ok.id, '123e4567-e89b-12d3-a456-426614174000');
    expect(parseDeepLink('https://evil.com/accident/123'), isNull);
    expect(parseDeepLink('helix://unknown/123e4567-e89b-12d3-a456-426614174000'), isNull);
    expect(parseDeepLink('helix://accident/not-a-uuid'), isNull);
  });

  test('notification targets apply the same rules', () {
    final link = targetFromNotification({'entity': 'fuel', 'id': '123e4567-e89b-12d3-a456-426614174000'});
    expect(link!.kind, DeepLinkKind.fuel);
    expect(targetFromNotification({'entity': 'fuel', 'id': 'bogus'}), isNull);
    expect(targetFromNotification({'entity': 'evil'}), isNull);
  });
}
