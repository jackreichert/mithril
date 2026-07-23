-- SEEDED DEFECT (deploy-coupled migration): in-place rename. The moment this
-- runs, every still-running instance of the PREVIOUS release (which selects
-- full_name) starts throwing. Not expand-contract: no add-column phase, no
-- dual-write window, no later contract release.
ALTER TABLE users RENAME COLUMN full_name TO display_name;
