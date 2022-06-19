# Copyright 2022 Joshua Wong.
# SPDX-License-Identifier: Apache-2.0

{
  description = "project skeleton templates";

  outputs = { self }: {
    templates = {

      rust = {
        path = ./rust;
        description = "Rust template using Naersk and Fenix";
      };

      haskell = {
        path = ./haskell;
        description = "Haskell template";
      };

    };
  };
}