import { api } from '@/app/api'
import type { PatientDto, PatientFormDto } from '../types/patient.types'

export const patientenApi = api.injectEndpoints({
  endpoints: (builder) => ({
    getPatienten: builder.query<PatientDto[], void>({
      query: () => '/patienten',
      providesTags: ['Patienten'],
    }),
    getPatient: builder.query<PatientDto, string>({
      query: (id) => `/patienten/${id}`,
      providesTags: (_result, _error, id) => [{ type: 'Patienten', id }],
    }),
    createPatient: builder.mutation<PatientDto, PatientFormDto>({
      query: (body) => ({
        url: '/patienten',
        method: 'POST',
        body,
      }),
      invalidatesTags: ['Patienten'],
    }),
    updatePatient: builder.mutation<PatientDto, { id: string; data: PatientFormDto }>({
      query: ({ id, data }) => ({
        url: `/patienten/${id}`,
        method: 'PATCH',
        body: data,
      }),
      invalidatesTags: (_result, _error, { id }) => [
        { type: 'Patienten', id },
        'Patienten',
      ],
    }),
    deletePatient: builder.mutation<void, string>({
      query: (id) => ({
        url: `/patienten/${id}`,
        method: 'DELETE',
      }),
      invalidatesTags: ['Patienten'],
    }),
  }),
})

export const {
  useGetPatientenQuery,
  useGetPatientQuery,
  useCreatePatientMutation,
  useUpdatePatientMutation,
  useDeletePatientMutation,
} = patientenApi
