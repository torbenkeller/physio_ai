import { api } from '@/app/api'
import type { ProfileDto, ProfileFormDto } from '../types/profil.types'

export const profileApi = api.injectEndpoints({
  endpoints: (builder) => ({
    getProfile: builder.query<ProfileDto | null, void>({
      query: () => '/profile',
      providesTags: ['Profile'],
    }),
    createProfile: builder.mutation<ProfileDto, ProfileFormDto>({
      query: (body) => ({
        url: '/profile',
        method: 'POST',
        body,
      }),
      invalidatesTags: ['Profile'],
    }),
    updateProfile: builder.mutation<ProfileDto | null, ProfileFormDto>({
      query: (body) => ({
        url: '/profile',
        method: 'PATCH',
        body,
      }),
      invalidatesTags: ['Profile'],
    }),
  }),
})

export const { useGetProfileQuery, useCreateProfileMutation, useUpdateProfileMutation } = profileApi
