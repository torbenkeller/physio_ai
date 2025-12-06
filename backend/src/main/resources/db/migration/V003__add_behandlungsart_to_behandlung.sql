ALTER TABLE behandlungen
ADD COLUMN behandlungsart_id UUID REFERENCES behandlungsarten(id);
