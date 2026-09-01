"""Module extensions for this language module."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def _download_plugins(module_ctx):
    """Download plugins."""

    # protobuf-javascript plugin
    for version, platform, hash in [
        # renovate-gh-plugin: protocolbuffers/protobuf-javascript
        ("v3.21.4", "darwin-arm64", "c8ee4890625f3eb134072ea6111b757cce541897657a50f05c5170558773acea"),
        ("v3.21.4", "darwin-x86_64", "af7665e12f6b76c9dbad9f09c3ec925f2c45b268e344de5356945bb2be098b1e"),
        ("v3.21.4", "linux-arm64", "87eb5158e8a914c47f8fda43bb04575ac2f7c68db5ee4289b3e689acf2843bfd"),
        ("v3.21.4", "linux-x86_64", "4966d0dce71a637b3b46de511aefc52c5df449159c6acbd7967ba742944012fd"),
        # ("v3.21.4", "windows-arm64", ""),
        ("v3.21.4", "windows-x86_64", "d0c701617ff0286462875ba0a6019f29de2ca3fe1740a55d6540558b39e44819"),
    ]:
        http_archive(
            name = "protoc_gen_protobuf_javascript_plugin_{}".format(platform.replace("-", "_")),
            sha256 = hash,
            url = "https://github.com/protocolbuffers/protobuf-javascript/releases/download/{0}/protobuf-javascript-{1}-{2}.zip".format(
                version,
                version[1:],
                platform.replace("windows-x86_64", "win64").replace("darwin", "osx").replace("arm64", "aarch_64"),
            ),
            build_file_content = """exports_files(glob(["**/*"]))""",
            strip_prefix = "protobuf-javascript-{}-win64".format(version[1:]) if platform == "windows-x86_64" else "",
        )

    # grpc-web plugin
    for version, platform, hash in [
        # renovate-gh-plugin: grpc/grpc-web
        ("2.1.1", "darwin-arm64", "3e1dbc5a440d869a5b1ac9fe4240d59db47c993c7279443ae6b4c0fd7faafd89"),
        ("2.1.1", "darwin-x86_64", "3e1dbc5a440d869a5b1ac9fe4240d59db47c993c7279443ae6b4c0fd7faafd89"),
        ("2.1.1", "linux-arm64", "e95f306f16c17cac80280e0964c0095073433232f94b025fe41652a0eeacbaea"),
        ("2.1.1", "linux-x86_64", "d7f0000b84ecebceeb317204f60dc2716708f9276d11ae8b4b5d3a10af49d65f"),
        ("2.1.1", "windows-arm64", "1b453da884a3e1d4710a92d94e38634c98840a0d0767cb70d7dd9cfb3d1e5727"),
        ("2.1.1", "windows-x86_64", "206fde8d99a75a1586fe13164ce0e7497afd358c0cf47c75dbebf3423dd35873"),
    ]:
        http_file(
            name = "protoc_gen_grpc_web_plugin_{}".format(platform.replace("-", "_")),
            sha256 = hash,
            url = "https://github.com/grpc/grpc-web/releases/download/{0}/protoc-gen-grpc-web-{0}-{1}{2}".format(
                version,
                platform.replace("arm64", "aarch64"),
                ".exe" if "windows" in platform else "",
            ),
            executable = True,
        )

    return module_ctx.extension_metadata(
        root_module_direct_deps = "all",
        root_module_direct_dev_deps = [],
    )

download_plugins = module_extension(
    implementation = _download_plugins,
)
