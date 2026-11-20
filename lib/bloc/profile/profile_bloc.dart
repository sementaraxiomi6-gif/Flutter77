
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_store/resource/model/customer_model.dart';
import 'package:food_store/resource/remote/profile_remote_resource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRemoteResource profileRemoteResource;

  ProfileBloc(this.profileRemoteResource)
      : super(const ProfileState.initial()) {
    on<_LoadProfile>((event, emit) async {
      emit(const ProfileState.loading());

      final result = await profileRemoteResource.fetchProfile();

      result.fold(
        (error) => emit(ProfileState.error(error)),
        (profile) => emit(ProfileState.loadedProfile(profile)),
      );
    });

    on<_UpdateProfile>((event, emit) async {
      emit(const ProfileState.loading());

      final result = await profileRemoteResource.updateProfile(
        name: event.name,
        email: event.email,
        image: event.image,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );

      result.fold(
        (error) => emit(
          ProfileState.failure(
            error: error is Map<String, dynamic>
                ? error
                : {'message': error.toString()},
          ),
        ),
        (message) => emit(ProfileState.updatedProfile(message)),
      );
    });
  }
}
