import { api } from '@/app/api'
import type {
  PatientenakteDto,
  FreieNotizDto,
  BehandlungsEintragDto,
  FreieNotizFormDto,
  NotizUpdateDto,
  PinUpdateDto,
} from '../types/patientenakte.types'

export const patientenakteApi = api.injectEndpoints({
  endpoints: (builder) => ({
    getPatientenakte: builder.query<PatientenakteDto, string>({
      query: (patientId) => `/patientenakte/${patientId}`,
      providesTags: (_result, _error, patientId) => [{ type: 'Patientenakte', id: patientId }],
    }),

    createFreieNotiz: builder.mutation<
      FreieNotizDto,
      { patientId: string; data: FreieNotizFormDto }
    >({
      query: ({ patientId, data }) => ({
        url: `/patientenakte/${patientId}/notizen`,
        method: 'POST',
        body: data,
      }),
      invalidatesTags: (_result, _error, { patientId }) => [
        { type: 'Patientenakte', id: patientId },
      ],
    }),

    deleteFreieNotiz: builder.mutation<void, { eintragId: string; patientId: string }>({
      query: ({ patientId, eintragId }) => ({
        url: `/patientenakte/${patientId}/notizen/${eintragId}`,
        method: 'DELETE',
      }),
      invalidatesTags: (_result, _error, { patientId }) => [
        { type: 'Patientenakte', id: patientId },
      ],
    }),

    updateBehandlungsNotiz: builder.mutation<
      BehandlungsEintragDto,
      { eintragId: string; patientId: string; data: NotizUpdateDto }
    >({
      query: ({ patientId, eintragId, data }) => ({
        url: `/patientenakte/${patientId}/behandlungen/${eintragId}/notiz`,
        method: 'PATCH',
        body: data,
      }),
      invalidatesTags: (_result, _error, { patientId }) => [
        { type: 'Patientenakte', id: patientId },
      ],
    }),

    updateFreieNotiz: builder.mutation<
      FreieNotizDto,
      { eintragId: string; patientId: string; data: NotizUpdateDto }
    >({
      query: ({ patientId, eintragId, data }) => ({
        url: `/patientenakte/${patientId}/notizen/${eintragId}`,
        method: 'PATCH',
        body: data,
      }),
      invalidatesTags: (_result, _error, { patientId }) => [
        { type: 'Patientenakte', id: patientId },
      ],
    }),

    pinBehandlungsEintrag: builder.mutation<
      BehandlungsEintragDto,
      { eintragId: string; patientId: string; data: PinUpdateDto }
    >({
      query: ({ patientId, eintragId, data }) => ({
        url: `/patientenakte/${patientId}/behandlungen/${eintragId}/pin`,
        method: 'PATCH',
        body: data,
      }),
      invalidatesTags: (_result, _error, { patientId }) => [
        { type: 'Patientenakte', id: patientId },
      ],
    }),

    pinFreieNotiz: builder.mutation<
      FreieNotizDto,
      { eintragId: string; patientId: string; data: PinUpdateDto }
    >({
      query: ({ patientId, eintragId, data }) => ({
        url: `/patientenakte/${patientId}/notizen/${eintragId}/pin`,
        method: 'PATCH',
        body: data,
      }),
      invalidatesTags: (_result, _error, { patientId }) => [
        { type: 'Patientenakte', id: patientId },
      ],
    }),
  }),
})

export const {
  useGetPatientenakteQuery,
  useCreateFreieNotizMutation,
  useDeleteFreieNotizMutation,
  useUpdateBehandlungsNotizMutation,
  useUpdateFreieNotizMutation,
  usePinBehandlungsEintragMutation,
  usePinFreieNotizMutation,
} = patientenakteApi
