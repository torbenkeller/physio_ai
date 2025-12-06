import { api } from '@/app/api'
import type {
  RezeptDto,
  RezeptCreateDto,
  RezeptUpdateDto,
  BehandlungsartDto,
  RezeptEinlesenResponse,
} from '../types/rezept.types'

export const rezepteApi = api.injectEndpoints({
  endpoints: (builder) => ({
    getRezepte: builder.query<RezeptDto[], void>({
      query: () => '/rezepte',
      providesTags: ['Rezepte'],
    }),
    getRezept: builder.query<RezeptDto, string>({
      query: (id) => `/rezepte/${id}`,
      providesTags: (_result, _error, id) => [{ type: 'Rezepte', id }],
    }),
    getBehandlungsarten: builder.query<BehandlungsartDto[], void>({
      query: () => '/rezepte/behandlungsarten',
    }),
    createRezept: builder.mutation<RezeptDto, RezeptCreateDto>({
      query: (body) => ({
        url: '/rezepte',
        method: 'POST',
        body,
      }),
      invalidatesTags: ['Rezepte'],
    }),
    updateRezept: builder.mutation<RezeptDto, { id: string; data: RezeptUpdateDto }>({
      query: ({ id, data }) => ({
        url: `/rezepte/${id}`,
        method: 'PATCH',
        body: data,
      }),
      invalidatesTags: (_result, _error, { id }) => [
        { type: 'Rezepte', id },
        'Rezepte',
      ],
    }),
    deleteRezept: builder.mutation<void, string>({
      query: (id) => ({
        url: `/rezepte/${id}`,
        method: 'DELETE',
      }),
      invalidatesTags: ['Rezepte'],
    }),
    uploadRezeptImage: builder.mutation<RezeptEinlesenResponse | null, FormData>({
      query: (body) => ({
        url: '/rezepte/createFromImage',
        method: 'POST',
        body,
      }),
    }),
  }),
})

export const {
  useGetRezepteQuery,
  useGetRezeptQuery,
  useGetBehandlungsartenQuery,
  useCreateRezeptMutation,
  useUpdateRezeptMutation,
  useDeleteRezeptMutation,
  useUploadRezeptImageMutation,
} = rezepteApi
