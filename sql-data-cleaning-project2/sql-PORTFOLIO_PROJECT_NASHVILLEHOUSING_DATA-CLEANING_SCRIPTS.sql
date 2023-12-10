-- Cleaning Data in SQL Queries

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing;

-- Standarize Date Format
SELECT 
	SaleDate,
	CONVERT(Date, SaleDate) AS Date
FROM PortfolioProject.dbo.NashvilleHousing;

-- Populate Property Address Data
SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing;


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS a
JOIN PortfolioProject.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
		AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS a
JOIN PortfolioProject.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
		AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

-- Breaking out Address into individual columns (Address, City, State)
SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing;

SELECT					                                      /* -1 and +1 is allowing us to ignore the ',' so it's not being displayed on any results */
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN (PropertyAddress)) AS City
FROM PortfolioProject.dbo.NashvilleHousing;


		-- Create las new columns for Address and City
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255),
    PropertySplitCity NVARCHAR(255);

		
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);


UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

		-- Show results for verification
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing;



SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) as OwnerStreetAddress,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),2) as OwnerCityAddress,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) as OwnerStateAddress
	FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1);

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing;

-- Change Y and N to 'Yes' and 'No' in "Sold as Vacant" field

SELECT 
	DISTINCT(SoldAsVacant), 
	COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject.dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


-- Remove duplicates
WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY 
	ParcelID, 
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID) row_num

FROM PortfolioProject.dbo.NashvilleHousing)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

   /* Deleting duplicates */
WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY 
	ParcelID, 
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID) row_num

FROM PortfolioProject.dbo.NashvilleHousing)
DELETE
FROM RowNumCTE
WHERE row_num > 1;

	/* Check if duplicates are correctly deleted running again the code right under the 'Remove duplicates' line */

