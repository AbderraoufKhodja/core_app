class SwapTooltipsState {
  bool isRewindIntroduced;
  bool isSwapsBoardIntroduced;
  bool isSwapChatsIntroduced;
  bool isSwapSettingsIntroduced;
  bool isSwapLocationIntroduced;

  SwapTooltipsState({
    required this.isRewindIntroduced,
    required this.isSwapsBoardIntroduced,
    required this.isSwapChatsIntroduced,
    required this.isSwapSettingsIntroduced,
    required this.isSwapLocationIntroduced,
  });

  factory SwapTooltipsState.initial() {
    return SwapTooltipsState(
      isRewindIntroduced: false,
      isSwapsBoardIntroduced: false,
      isSwapChatsIntroduced: false,
      isSwapSettingsIntroduced: false,
      isSwapLocationIntroduced: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      STLabels.isRewindIntroduced.name: isRewindIntroduced,
      STLabels.isSwapsBoardIntroduced.name: isSwapsBoardIntroduced,
      STLabels.isSwapChatsIntroduced.name: isSwapChatsIntroduced,
      STLabels.isSwapSettingsIntroduced.name: isSwapSettingsIntroduced,
      STLabels.isSwapLocationIntroduced.name: isSwapLocationIntroduced,
    };
  }

  factory SwapTooltipsState.fromJson(Map<String, dynamic> doc) {
    return SwapTooltipsState(
      isRewindIntroduced: doc[STLabels.isRewindIntroduced.name],
      isSwapsBoardIntroduced: doc[STLabels.isSwapsBoardIntroduced.name],
      isSwapChatsIntroduced: doc[STLabels.isSwapChatsIntroduced.name],
      isSwapSettingsIntroduced: doc[STLabels.isSwapSettingsIntroduced.name],
      isSwapLocationIntroduced: doc[STLabels.isSwapLocationIntroduced.name],
    );
  }
}

enum STLabels {
  isRewindIntroduced,
  isSwapsBoardIntroduced,
  isSwapChatsIntroduced,
  isSwapSettingsIntroduced,
  isSwapLocationIntroduced,
}
