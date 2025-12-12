// API
export {
  useGetPatientenakteQuery,
  useCreateFreieNotizMutation,
  useDeleteFreieNotizMutation,
  useUpdateBehandlungsNotizMutation,
  useUpdateFreieNotizMutation,
  usePinBehandlungsEintragMutation,
  usePinFreieNotizMutation,
} from './api/patientenakteApi'

// Components
export { BehandlungsverlaufTimeline } from './components/BehandlungsverlaufTimeline'
export { KategorieBadge } from './components/KategorieBadge'

// Types
export type {
  PatientenakteDto,
  AktenEintragDto,
  BehandlungsEintragDto,
  FreieNotizDto,
  NotizDto,
  FreieNotizFormDto,
  NotizUpdateDto,
  PinUpdateDto,
  NotizKategorie,
} from './types/patientenakte.types'

export { isBehandlungsEintrag, isFreieNotiz } from './types/patientenakte.types'
