import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useGetPatientenQuery, useDeletePatientMutation } from '../api/patientenApi'
import { PageHeader } from '@/shared/components/PageHeader'
import { Button } from '@/shared/components/ui/button'
import { Input } from '@/shared/components/ui/input'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/shared/components/ui/table'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/shared/components/ui/dialog'
import { Plus, Search, Trash2, Eye } from 'lucide-react'
import { toast } from 'sonner'
import type { PatientDto } from '../types/patient.types'

export const PatientenListe = () => {
  const { data: patienten, isLoading, error } = useGetPatientenQuery()
  const [deletePatient] = useDeletePatientMutation()
  const [searchTerm, setSearchTerm] = useState('')
  const [deleteDialog, setDeleteDialog] = useState<PatientDto | null>(null)

  const filteredPatienten = patienten?.filter((patient) => {
    const fullName = `${patient.vorname} ${patient.nachname}`.toLowerCase()
    return fullName.includes(searchTerm.toLowerCase())
  })

  const handleDelete = async () => {
    if (!deleteDialog) return
    try {
      await deletePatient(deleteDialog.id).unwrap()
      toast.success('Patient erfolgreich gelöscht')
      setDeleteDialog(null)
    } catch {
      toast.error('Fehler beim Löschen des Patienten')
    }
  }

  const formatDate = (dateString: string | null) => {
    if (!dateString) return '-'
    return new Date(dateString).toLocaleDateString('de-DE')
  }

  if (isLoading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="text-muted-foreground">Laden...</div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="text-destructive">Fehler beim Laden der Patienten</div>
      </div>
    )
  }

  return (
    <div>
      <PageHeader
        title="Patienten"
        description="Verwalten Sie Ihre Patientenstammdaten"
        actions={
          <Button asChild>
            <Link to="/patienten/neu">
              <Plus className="mr-2 h-4 w-4" />
              Neuer Patient
            </Link>
          </Button>
        }
      />

      <div className="mb-6">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            placeholder="Patienten suchen..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10"
          />
        </div>
      </div>

      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Geburtsdatum</TableHead>
              <TableHead>Telefon</TableHead>
              <TableHead>E-Mail</TableHead>
              <TableHead className="w-[100px]">Aktionen</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filteredPatienten?.length === 0 ? (
              <TableRow>
                <TableCell colSpan={5} className="h-24 text-center">
                  Keine Patienten gefunden
                </TableCell>
              </TableRow>
            ) : (
              filteredPatienten?.map((patient) => (
                <TableRow key={patient.id}>
                  <TableCell className="font-medium">
                    {patient.titel && `${patient.titel} `}
                    {patient.vorname} {patient.nachname}
                  </TableCell>
                  <TableCell>{formatDate(patient.geburtstag)}</TableCell>
                  <TableCell>{patient.telMobil || patient.telFestnetz || '-'}</TableCell>
                  <TableCell>{patient.email || '-'}</TableCell>
                  <TableCell>
                    <div className="flex items-center gap-2">
                      <Button variant="ghost" size="icon-sm" asChild>
                        <Link to={`/patienten/${patient.id}`}>
                          <Eye className="h-4 w-4" />
                        </Link>
                      </Button>
                      <Button
                        variant="ghost"
                        size="icon-sm"
                        onClick={() => setDeleteDialog(patient)}
                      >
                        <Trash2 className="h-4 w-4 text-destructive" />
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      <Dialog open={!!deleteDialog} onOpenChange={() => setDeleteDialog(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Patient löschen</DialogTitle>
            <DialogDescription>
              Möchten Sie den Patienten "{deleteDialog?.vorname} {deleteDialog?.nachname}" wirklich löschen?
              Diese Aktion kann nicht rückgängig gemacht werden.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteDialog(null)}>
              Abbrechen
            </Button>
            <Button variant="destructive" onClick={handleDelete}>
              Löschen
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
