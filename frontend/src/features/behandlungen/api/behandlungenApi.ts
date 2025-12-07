import { api } from '@/app/api'
import type {
  BehandlungDto,
  BehandlungFormDto,
  BehandlungKalenderDto,
  VerschiebeBehandlungDto,
  WeeklyCalendarResponse,
  ConflictCheckRequest,
  ConflictResult,
} from '../types/behandlung.types'

export const behandlungenApi = api.injectEndpoints({
  endpoints: (builder) => ({
    getBehandlungen: builder.query<BehandlungDto[], void>({
      query: () => '/behandlungen',
      providesTags: ['Behandlungen'],
    }),
    getBehandlung: builder.query<BehandlungDto, string>({
      query: (id) => `/behandlungen/${id}`,
      providesTags: (_result, _error, id) => [{ type: 'Behandlungen', id }],
    }),
    getBehandlungenByPatient: builder.query<BehandlungDto[], string>({
      query: (patientId) => `/behandlungen/patient/${patientId}`,
      providesTags: ['Behandlungen'],
    }),
    getUnassignedBehandlungenByPatient: builder.query<BehandlungKalenderDto[], string>({
      query: (patientId) => `/behandlungen/patient/${patientId}/unassigned`,
      providesTags: ['Behandlungen'],
    }),
    getBehandlungenByRezept: builder.query<BehandlungKalenderDto[], string>({
      query: (rezeptId) => `/behandlungen/rezept/${rezeptId}`,
      providesTags: ['Behandlungen'],
    }),
    getWeeklyCalendar: builder.query<WeeklyCalendarResponse, string>({
      query: (date) => `/behandlungen/calender/week?date=${date}`,
      providesTags: ['Behandlungen'],
    }),
    createBehandlung: builder.mutation<BehandlungDto, BehandlungFormDto>({
      query: (body) => ({
        url: '/behandlungen',
        method: 'POST',
        body,
      }),
      invalidatesTags: ['Behandlungen'],
    }),
    updateBehandlung: builder.mutation<BehandlungDto, { id: string; data: BehandlungFormDto }>({
      query: ({ id, data }) => ({
        url: `/behandlungen/${id}`,
        method: 'PUT',
        body: data,
      }),
      invalidatesTags: ['Behandlungen'],
    }),
    deleteBehandlung: builder.mutation<void, string>({
      query: (id) => ({
        url: `/behandlungen/${id}`,
        method: 'DELETE',
      }),
      invalidatesTags: ['Behandlungen'],
    }),
    verschiebeBehandlung: builder.mutation<BehandlungDto, { id: string; data: VerschiebeBehandlungDto }>({
      query: ({ id, data }) => ({
        url: `/behandlungen/${id}/verschiebe`,
        method: 'PUT',
        body: data,
      }),
      invalidatesTags: ['Behandlungen'],
    }),
    createBehandlungenBatch: builder.mutation<BehandlungDto[], BehandlungFormDto[]>({
      query: (body) => ({
        url: '/behandlungen/batch',
        method: 'POST',
        body,
      }),
      invalidatesTags: ['Behandlungen'],
    }),
    checkConflicts: builder.mutation<ConflictResult[], ConflictCheckRequest>({
      query: (body) => ({
        url: '/behandlungen/check-conflicts',
        method: 'POST',
        body,
      }),
    }),
  }),
})

export const {
  useGetBehandlungenQuery,
  useGetBehandlungQuery,
  useGetBehandlungenByPatientQuery,
  useGetUnassignedBehandlungenByPatientQuery,
  useGetBehandlungenByRezeptQuery,
  useGetWeeklyCalendarQuery,
  useCreateBehandlungMutation,
  useUpdateBehandlungMutation,
  useDeleteBehandlungMutation,
  useVerschiebeBehandlungMutation,
  useCreateBehandlungenBatchMutation,
  useCheckConflictsMutation,
} = behandlungenApi
