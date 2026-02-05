import 'package:flutter_bloc/flutter_bloc.dart';
import 'group_event.dart';
import 'group_state.dart';
import '../../../data/repositories/group_repository_impl.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepositoryImpl repository;

  GroupBloc({required this.repository}) : super(GroupInitial()) {
    on<LoadGroups>((event, emit) async {
      emit(GroupLoading());
      try {
        final groupNames = await repository.fetchGroupNames();
        emit(GroupLoaded(groupNames));
      } catch (e) {
        emit(GroupError(e.toString()));
      }
    });
  }
}
