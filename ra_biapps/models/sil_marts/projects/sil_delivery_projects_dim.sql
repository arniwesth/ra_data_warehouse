{{
    config(
        unique_key='delivery_project_pk',
        alias='delivery_projects_dim'
    )
}}
WITH delivery_projects AS
  (
  SELECT *
  FROM   {{ ref('sde_delivery_projects_ds') }}
  )
SELECT
   GENERATE_UUID() as delivery_project_pk,
   p.source,
   p.project_id,
   p.lead_user_id,
   p.project_name,
   p.project_status,
   p.project_notes,
   p.project_type as project_type,
   p.project_category_description,
   p.project_category_name,
   p.project_created_at_ts,
   p.project_modified_at_ts
FROM
   delivery_projects p