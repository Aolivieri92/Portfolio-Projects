
--Cleaning Data in SQL Queries

SELECT *
FROM project_1.dbo.NashvilleHousing


-- Standardizing Date format 

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM project_1.dbo.NashvilleHousing

UPDATE project_1.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE project_1.dbo.NashvilleHousing
Add SaleDateConverted DATE;

UPDATE project_1.dbo.NashvilleHousing
SET SaleDateConverted  = CONVERT(Date,SaleDate)

--Populate Address Data 


SELECT *
FROM project_1.dbo.NashvilleHousing
--Where PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
FROM project_1.dbo.NashvilleHousing a
JOIN project_1.dbo.NashvilleHousing b
  ON a.ParcelID = b.ParcelID
  AND a.[UNIQUEID ] <> b.[UNIQUEID ]
  WHERE a.PropertyAddress is null

  UPDATE a
  SET PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
  FROM project_1.dbo.NashvilleHousing a
JOIN project_1.dbo.NashvilleHousing b
  ON a.ParcelID = b.ParcelID
  AND a.[UNIQUEID ] <> b.[UNIQUEID ]
  WHERE a.PropertyAddress is null


  --Breaking out Address into individual columns (address,city,state)

  SELECT PropertyAddress
FROM project_1.dbo.NashvilleHousing
--WHERE PropertyAddress is null

SELECT
SUBSTRING(propertyaddress,1, CHARINDEX( ',', PropertyAddress)-1) AS ADDRESS,
SUBSTRING (propertyaddress, CHARINDEX( ',', PropertyAddress) +1, LEN(propertyaddress)) as ADDRESS
FROM project_1.dbo.NashvilleHousing


ALTER TABLE project_1.dbo.NashvilleHousing
Add PropterySplitAddress NVARCHAR(255);

UPDATE project_1.dbo.NashvilleHousing
SET PropterySplitAddress  = SUBSTRING(propertyaddress,1, CHARINDEX( ',', PropertyAddress)-1)

ALTER TABLE project_1.dbo.NashvilleHousing
Add PropterySplitCity NVARCHAR(255);

UPDATE project_1.dbo.NashvilleHousing
SET PropterySplitCity  = SUBSTRING (propertyaddress, CHARINDEX( ',', PropertyAddress) +1, LEN(propertyaddress))


SELECT *
FROM project_1.dbo.NashvilleHousing


SELECT owneraddress
FROM project_1.dbo.NashvilleHousing


SELECT 
PARSENAME(REPLACE(owneraddress, ',' , '.'), 3),
PARSENAME(REPLACE(owneraddress, ',' , '.'), 2),
PARSENAME(REPLACE(owneraddress, ',' , '.'), 1)
FROM project_1.dbo.NashvilleHousing



ALTER TABLE project_1.dbo.NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

UPDATE project_1.dbo.NashvilleHousing
SET OwnerSplitAddress  = PARSENAME(REPLACE(owneraddress, ',' , '.'), 3)

ALTER TABLE project_1.dbo.NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

UPDATE project_1.dbo.NashvilleHousing
SET OwnerSplitCity  = PARSENAME(REPLACE(owneraddress, ',' , '.'), 2)


ALTER TABLE project_1.dbo.NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

UPDATE project_1.dbo.NashvilleHousing
SET OwnerSplitState  = PARSENAME(REPLACE(owneraddress, ',' , '.'), 1)


--Change Y and N to Yes and No in 'Sold as Vacant'

SELECT DISTINCT(soldasvacant), COUNT(soldasvacant)
FROM project_1.dbo.NashvilleHousing
GROUP BY soldasvacant
ORDER BY 2

SELECT soldasvacant
 , CASE WHEN soldasvacant = 'Y' then 'Yes'
      WHEN soldasvacant = 'N' then 'No'
	  ELSE soldasvacant
	  END
FROM project_1.dbo.NashvilleHousing

UPDATE Nashvillehousing
SET soldasvacant = CASE WHEN soldasvacant = 'Y' then 'Yes'
      WHEN soldasvacant = 'N' then 'No'
	  ELSE soldasvacant
	  END
FROM project_1.dbo.NashvilleHousing



--Removing Duplicates

SELECT *
FROM project_1.dbo.NashvilleHousing


WITH RowNumCTE AS (
SELECT *, 
    ROW_NUMBER() OVER (
	PARTITION BY ParcelId,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				    UniqueID 
					) row_num

FROM project_1.dbo.NashvilleHousing
--ORDER BY ParcelId
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

SELECT *
FROM project_1.dbo.NashvilleHousing

--Delete Unused Columns 

SELECT *
FROM project_1.dbo.NashvilleHousing

ALTER TABLE project_1.dbo.NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress

ALTER TABLE  project_1.dbo.NashvilleHousing
DROP COLUMN SaleDate



