import { useState, useEffect, useRef, useCallback, useLayoutEffect } from 'react'
import { Link } from 'react-router-dom'
import { toast } from 'sonner'
import { MoreVertical, Pencil, Trash2, Undo2, ExternalLink } from 'lucide-react'
import { Button } from '@/shared/components/ui/button'
import { Label } from '@/shared/components/ui/label'
import { Separator } from '@/shared/components/ui/separator'
import { Card } from '@/shared/components/ui/card'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/shared/components/ui/dropdown-menu'
import { useUpdateBemerkungMutation } from '../api/behandlungenApi'
import { DeleteBehandlungDialog } from './DeleteBehandlungDialog'
import { BehandlungEditDialog } from './BehandlungEditDialog'
import type { BehandlungKalenderDto } from '../types/behandlung.types'
import type { BehandlungsartDto } from '@/features/rezepte/types/rezept.types'

interface BehandlungDetailPopoverProps {
  behandlung: BehandlungKalenderDto
  behandlungsarten: BehandlungsartDto[] | undefined
  open: boolean
  onOpenChange: (open: boolean) => void
  anchorEl: HTMLElement | null
}

const DEBOUNCE_DELAY = 500
const POPOVER_WIDTH = 320
const POPOVER_MARGIN = 16

export const BehandlungDetailPopover = ({
  behandlung,
  behandlungsarten,
  open,
  onOpenChange,
  anchorEl,
}: BehandlungDetailPopoverProps) => {
  const [updateBemerkung] = useUpdateBemerkungMutation()

  // Local bemerkung state for editing
  const [bemerkung, setBemerkung] = useState(behandlung.bemerkung || '')
  const [originalBemerkung, setOriginalBemerkung] = useState(behandlung.bemerkung || '')
  const [hasChanges, setHasChanges] = useState(false)
  const [isSaving, setIsSaving] = useState(false)

  // Dialog states
  const [showDeleteDialog, setShowDeleteDialog] = useState(false)
  const [showEditDialog, setShowEditDialog] = useState(false)

  // Debounce timer ref
  const debounceTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  // Popover ref for measuring actual height
  const popoverRef = useRef<HTMLDivElement>(null)
  const [popoverPosition, setPopoverPosition] = useState({ top: 0, left: 0 })

  // Reset state when behandlung or popover changes
  useEffect(() => {
    if (open) {
      setBemerkung(behandlung.bemerkung || '')
      setOriginalBemerkung(behandlung.bemerkung || '')
      setHasChanges(false)
    }
  }, [open, behandlung.bemerkung])

  // Cleanup debounce timer on unmount
  useEffect(() => {
    return () => {
      if (debounceTimerRef.current) {
        clearTimeout(debounceTimerRef.current)
      }
    }
  }, [])

  const saveBemerkung = useCallback(
    async (value: string) => {
      setIsSaving(true)
      try {
        await updateBemerkung({
          id: behandlung.id,
          data: { bemerkung: value || null },
        }).unwrap()
        setOriginalBemerkung(value)
        setHasChanges(false)
      } catch {
        toast.error('Bemerkung konnte nicht gespeichert werden')
      } finally {
        setIsSaving(false)
      }
    },
    [behandlung.id, updateBemerkung]
  )

  const handleBemerkungChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    const newValue = e.target.value
    setBemerkung(newValue)
    setHasChanges(newValue !== originalBemerkung)

    // Clear existing timer
    if (debounceTimerRef.current) {
      clearTimeout(debounceTimerRef.current)
    }

    // Set new timer for auto-save
    debounceTimerRef.current = setTimeout(() => {
      if (newValue !== originalBemerkung) {
        saveBemerkung(newValue)
      }
    }, DEBOUNCE_DELAY)
  }

  const handleUndo = () => {
    // Cancel pending save
    if (debounceTimerRef.current) {
      clearTimeout(debounceTimerRef.current)
    }
    setBemerkung(originalBemerkung)
    setHasChanges(false)
  }

  // Format date and time
  const startDate = new Date(behandlung.startZeit)
  const endDate = new Date(behandlung.endZeit)
  const formattedDate = startDate.toLocaleDateString('de-DE', {
    weekday: 'long',
    day: '2-digit',
    month: 'long',
    year: 'numeric',
  })
  const formattedTime = `${startDate.toLocaleTimeString('de-DE', {
    hour: '2-digit',
    minute: '2-digit',
  })} - ${endDate.toLocaleTimeString('de-DE', {
    hour: '2-digit',
    minute: '2-digit',
  })} Uhr`

  // Get behandlungsart name
  const behandlungsart = behandlungsarten?.find((b) => b.id === behandlung.behandlungsartId)

  const patientFullName = behandlung.patient.name

  // Calculate position based on anchor and popover dimensions
  const calculatePosition = useCallback(
    (popoverHeight: number) => {
      if (!anchorEl) return { top: 0, left: 0 }

      const rect = anchorEl.getBoundingClientRect()
      const viewportWidth = window.innerWidth
      const viewportHeight = window.innerHeight

      // Calculate available space in each direction
      const spaceRight = viewportWidth - rect.right - POPOVER_MARGIN
      const spaceLeft = rect.left - POPOVER_MARGIN

      let left: number
      let top: number

      // Horizontal positioning: prefer right, fall back to left
      if (spaceRight >= POPOVER_WIDTH) {
        left = rect.right + 8
      } else if (spaceLeft >= POPOVER_WIDTH) {
        left = rect.left - POPOVER_WIDTH - 8
      } else {
        // Not enough space on either side, position at the edge with most space
        if (spaceRight >= spaceLeft) {
          left = viewportWidth - POPOVER_WIDTH - POPOVER_MARGIN
        } else {
          left = POPOVER_MARGIN
        }
      }

      // Vertical positioning strategy:
      // 1. Try to align popover top with anchor top (preferred)
      // 2. If popover would extend below viewport, align popover bottom with anchor bottom

      const popoverTopAligned = rect.top
      const popoverBottomAligned = rect.bottom - popoverHeight

      // Check if top-aligned popover fits in viewport
      const topAlignedFits = popoverTopAligned + popoverHeight <= viewportHeight - POPOVER_MARGIN

      if (topAlignedFits) {
        // Top-aligned fits: use it
        top = popoverTopAligned
      } else {
        // Top-aligned doesn't fit: align bottom of popover with bottom of anchor
        top = popoverBottomAligned
      }

      // Final bounds check - ensure popover doesn't go above viewport
      if (top < POPOVER_MARGIN) {
        top = POPOVER_MARGIN
      }

      // Ensure left is within bounds
      left = Math.max(
        POPOVER_MARGIN,
        Math.min(left, viewportWidth - POPOVER_WIDTH - POPOVER_MARGIN)
      )

      return { top, left }
    },
    [anchorEl]
  )

  // Update position after popover is rendered and we know its actual height
  useLayoutEffect(() => {
    if (open && popoverRef.current && anchorEl) {
      const popoverHeight = popoverRef.current.getBoundingClientRect().height
      const newPosition = calculatePosition(popoverHeight)
      setPopoverPosition(newPosition)
    }
  }, [open, anchorEl, calculatePosition])

  if (!open) return null

  return (
    <>
      {/* Backdrop to close on outside click */}
      <div className="fixed inset-0 z-40" onClick={() => onOpenChange(false)} />
      <Card
        ref={popoverRef}
        className="fixed z-50 p-4 shadow-lg animate-in fade-in-0 zoom-in-95"
        style={{
          top: popoverPosition.top,
          left: popoverPosition.left,
          width: POPOVER_WIDTH,
          maxHeight: `calc(100vh - ${POPOVER_MARGIN * 2}px)`,
          overflowY: 'auto',
        }}
      >
        <div className="space-y-4">
          {/* Header with patient name and menu */}
          <div className="flex items-start justify-between gap-2">
            <Link
              to={`/patienten/${behandlung.patient.id}`}
              className="group inline-flex items-center gap-1.5 font-semibold text-base hover:text-primary transition-colors"
            >
              {patientFullName}
              <ExternalLink className="h-3.5 w-3.5 opacity-0 group-hover:opacity-100 transition-opacity" />
            </Link>

            {/* Actions Menu */}
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="h-8 w-8 -mr-2 -mt-1">
                  <MoreVertical className="h-4 w-4" />
                  <span className="sr-only">Aktionen</span>
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuItem onClick={() => setShowEditDialog(true)}>
                  <Pencil className="h-4 w-4 mr-2" />
                  Bearbeiten
                </DropdownMenuItem>
                <DropdownMenuItem
                  onClick={() => setShowDeleteDialog(true)}
                  className="text-destructive focus:text-destructive"
                >
                  <Trash2 className="h-4 w-4 mr-2" />
                  Löschen
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>

          {/* Date and Time */}
          <div className="space-y-1">
            <p className="text-sm">{formattedDate}</p>
            <p className="text-sm text-muted-foreground">{formattedTime}</p>
          </div>

          {/* Behandlungsart */}
          {behandlungsart && (
            <div className="space-y-1">
              <Label className="text-xs text-muted-foreground">Behandlungsart</Label>
              <p className="text-sm">{behandlungsart.name}</p>
            </div>
          )}

          {/* Rezept Link */}
          {behandlung.rezeptId && (
            <div className="space-y-1">
              <Label className="text-xs text-muted-foreground">Rezept</Label>
              <Link
                to={`/rezepte/${behandlung.rezeptId}`}
                className="group inline-flex items-center gap-1.5 text-sm hover:text-primary transition-colors"
              >
                Rezept anzeigen
                <ExternalLink className="h-3 w-3 opacity-0 group-hover:opacity-100 transition-opacity" />
              </Link>
            </div>
          )}

          <Separator />

          {/* Bemerkung */}
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <Label className="text-xs text-muted-foreground">Bemerkung</Label>
              {hasChanges && (
                <Button variant="ghost" size="sm" className="h-6 px-2 text-xs" onClick={handleUndo}>
                  <Undo2 className="h-3 w-3 mr-1" />
                  Rückgängig
                </Button>
              )}
            </div>
            <textarea
              value={bemerkung}
              onChange={handleBemerkungChange}
              placeholder="Bemerkung hinzufügen..."
              className="flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 resize-none"
            />
            {isSaving && <p className="text-xs text-muted-foreground">Wird gespeichert...</p>}
          </div>
        </div>
      </Card>

      {/* Delete Dialog */}
      <DeleteBehandlungDialog
        open={showDeleteDialog}
        onOpenChange={setShowDeleteDialog}
        behandlungId={behandlung.id}
        patientName={patientFullName}
        startZeit={behandlung.startZeit}
        onSuccess={() => onOpenChange(false)}
      />

      {/* Edit Dialog */}
      <BehandlungEditDialog
        open={showEditDialog}
        onOpenChange={setShowEditDialog}
        behandlung={behandlung}
        behandlungsarten={behandlungsarten}
        onSuccess={() => onOpenChange(false)}
      />
    </>
  )
}
