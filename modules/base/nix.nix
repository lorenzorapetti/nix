{
  den.aspects.base.nixos = {
    # Cap NIX_BUILD_CORES so a single heavy derivation (e.g. a template-heavy C++
    # build) can't grab every core at once and blow through RAM+swap.
  };
}
