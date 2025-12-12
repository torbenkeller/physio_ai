-- Spring Modulith Event Publication Table
-- Required for @ApplicationModuleListener to persist events for guaranteed delivery
CREATE TABLE IF NOT EXISTS event_publication (
    id UUID PRIMARY KEY,
    listener_id VARCHAR(255) NOT NULL,
    event_type VARCHAR(255) NOT NULL,
    serialized_event TEXT NOT NULL,
    publication_date TIMESTAMP WITH TIME ZONE NOT NULL,
    completion_date TIMESTAMP WITH TIME ZONE
);

-- Index for faster querying of incomplete publications
CREATE INDEX idx_event_publication_incomplete ON event_publication (completion_date) WHERE completion_date IS NULL;
