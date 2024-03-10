import 'package:fibali/models/tooltips_state.dart';
import 'package:fibali/fibali_core/utils/strings.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class TooltipsIntroCubit extends HydratedCubit<SwapTooltipsState> {
  late TooltipParams tooltipLocation;
  late TooltipParams tooltipSettings;
  late TooltipParams tooltipBoard;
  late TooltipParams tooltipChats;
  late TooltipParams tooltipRewind;

  TooltipsIntroCubit() : super(SwapTooltipsState.initial()) {
    tooltipLocation = TooltipParams(
      JustTheController(),
      markToolIntroLocation,
      R.tooltipSwapLocationButtonDescription,
    );
    tooltipSettings = TooltipParams(
      JustTheController(),
      markToolIntroSettings,
      R.tooltipSwapSettingsButtonDescription,
    );
    tooltipBoard = TooltipParams(
      JustTheController(),
      markToolIntroBoard,
      R.tooltipSwapBoardButtonDescription,
    );
    tooltipChats = TooltipParams(
      JustTheController(),
      markToolIntroChats,
      R.tooltipSwapChatsButtonDescription,
    );
    tooltipRewind = TooltipParams(
      JustTheController(),
      markToolIntroRewind,
      R.tooltipSwapRewindButtonDescription,
    );
  }

  @override
  SwapTooltipsState? fromJson(Map<String, dynamic> json) {
    try {
      final tooltipsState = SwapTooltipsState.fromJson(json);
      return tooltipsState;
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SwapTooltipsState state) {
    return state.toJson();
  }

  void showNextTooltip() {
    if (!state.isSwapLocationIntroduced) {
      tooltipLocation.controller.showTooltip(immediately: true);
      return;
    }
    if (!state.isSwapSettingsIntroduced) {
      tooltipSettings.controller.showTooltip(immediately: true);
      return;
    }
    if (!state.isSwapsBoardIntroduced) {
      tooltipBoard.controller.showTooltip(immediately: true);
      return;
    }
    if (!state.isSwapChatsIntroduced) {
      tooltipChats.controller.showTooltip(immediately: true);
      return;
    }
    if (!state.isRewindIntroduced) {
      tooltipRewind.controller.showTooltip(immediately: true);
      return;
    }
  }

  void markToolIntroLocation() {
    state.isSwapLocationIntroduced = true;
    emit(state);
  }

  void markToolIntroSettings() {
    state.isSwapSettingsIntroduced = true;
    emit(state);
  }

  void markToolIntroBoard() {
    state.isSwapsBoardIntroduced = true;
    emit(state);
  }

  void markToolIntroChats() {
    state.isSwapChatsIntroduced = true;
    emit(state);
  }

  void markToolIntroRewind() {
    state.isRewindIntroduced = true;
    emit(state);
  }
}

class TooltipParams<JustTheController, T2> {
  final JustTheController controller;
  final Function function;
  final R string;

  TooltipParams(this.controller, this.function, this.string);
}
