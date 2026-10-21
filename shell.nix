let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = with pkgs; [
      # Build tools
      cmake
      ninja
      pkg-config

      # Vulkan Core & Headers
      vulkan-loader
      vulkan-headers
      vulkan-validation-layers
      shaderc

      # Windowing & Math
      glfw
      glm
    ];

    shelllHook = ''
      echo "Vulkan C++ development environment loaded"
      export VK_LAYER_PATH="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d"
    '';
  }
