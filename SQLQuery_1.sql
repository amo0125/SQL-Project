-- Cleaning Data in SQL Queries
SELECT *
FROM dbo.NashvilleHousingData


-- update data type by using Update 
Update NashvilleHousingdata
SET SaleDate = CONVERT(Date, Saledate)

SELECT Saledate
FROM dbo.NashvilleHousingData


-- Add new cloumn
ALTER TABLE NashvilleHousingData
Add SaleDateConverted Date;

Update NashvilleHousingData
SET SaleDateConverted = CONVERT(Date, Saledate)

SELECT SaleDateConverted
FROM dbo.NashvilleHousingData


-- Populate Property Address data
SELECT *
FROM NashvilleHousingData
-- WHERE PropertyAddress IS NULL
ORDER BY parcelID


-- Looking at same parcelID but different uniqueID which PropertyAddress is NULL
Select a.UniqueID,a.ParcelID, a.PropertyAddress, b.UniqueID,b.ParcelID, b.PropertyAddress
FROM dbo.NashvilleHousingData a
JOIN dbo.NashvilleHousingData b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL 


--Use ISNULL(expression, replacement_value) update the null column 
Select a.UniqueID,a.ParcelID, a.PropertyAddress, b.UniqueID,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.NashvilleHousingData a
JOIN dbo.NashvilleHousingData b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL 

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.NashvilleHousingData a
JOIN dbo.NashvilleHousingData b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL    


-- Breaking out Address into Individual Columns (Address, City, State)  
SELECT *
FROM NashvilleHousingData

SElECT SUBSTRING(PropertyAddress, 1, (CHARINDEX(',', PropertyAddress))) as Address
-- SUBSTRING( a string , starting position, extract how many number of letters)
-- CHARINDEX( search expression varchar(1), in string) given a number of position
FROM NashvilleHousingData

ALTER TABLE NashvilleHousingData
ADD PropertySplitAddress NVARCHAR(225);

UPDATE NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, (CHARINDEX(',', PropertyAddress)- 1))

ALTER TABLE NashvilleHousingData
ADD PropertysplitCity NVARCHAR(225)

-- to ignore ','
UPDATE NashvilleHousingData
SET PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


--  Breaking out Address into Individual Columns (Address, City, State) BY Using PARSENAME AND REPLACE
SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
-- PARSENAME('a string seperate by .', 'count from backward 1 2 3 ')
-- syntax PARSENAME ('object_name' , object_piece )
-- syntax REPLACE(string, from_string, new_string)
FROM dbo.NashvilleHOusingData

ALTER TABLE NashvilleHousingData
ADD OwnerSplitAddress NVARCHAR(225);

UPDATE NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousingData
ADD OwnersplitCity NVARCHAR(225)

UPDATE NashvilleHousingData
SET OwnersplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousingData
ADD OwnersplitState NVARCHAR(225)

UPDATE NashvilleHousingData
SET OwnersplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) 

SELECT *
FROM dbo.NashvilleHousingData


-- change 'y' and 'n' to 'yes' and 'no' In SoldAsVacant field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM dbo.NashvilleHousingData
GROUP BY SoldAsVacant

SELECT SoldAsVacant,CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END
FROM dbo.NashvilleHousingData    

UPDATE dbo.NashvilleHousingData    
SET SoldAsVacant =
    CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END


-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
-- ROW_NUMBER ( )  OVER ( [ PARTITION BY value_expression , ... [ n ] ] order_by_clause )
    ROW_NUMBER() OVER(
    PARTITION BY ParcelID,
    Propertyaddress,
    SalePrice,
    SaleDate,
    LegalReference
    ORDER BY 
    UniqueID
        )AS row_num
FROM dbo.NashvilleHousingData   
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

DELETE
FROM RowNumCTE
WHERE row_num >1


-- Delete unused columns
SELECT *
FROM dbo.NashvilleHousingData 

ALTER TABLE dbo.NashvilleHousingData 
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,SaleDate
