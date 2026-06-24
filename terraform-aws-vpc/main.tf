resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  tags = merge(local.common_tags, var.vpc_tags)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.igw_tags,
    {
        Name = "${var.project_name}-${var.environment}-igw"
    }
    
    )
}

resource "aws_subnet" "public" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]

  tags = merge(
    local.common_tags, 
    var.public_subnet_tags,
    {
        Name = "${var.project_name}-${var.environment}-public-${split("-", local.az_names[count.index])[2]}"
    }
    
    )
}

resource "aws_subnet" "private" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = merge(
    local.common_tags, var.private_subnet_tags,
    {
        Name = "${var.project_name}-${var.environment}-private-${split("-", local.az_names[count.index] )[2]}"
    }
    
    )
}


resource "aws_subnet" "database" {
  count      = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]

  tags = merge(
    local.common_tags, 
    var.database_subnet_tags,
     {
        Name = "${var.project_name}-${var.environment}-database-${split("-", local.az_names[count.index])[2]}"
    }
    )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-private-rt"
    }
    
    )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-public-rt"
    }
    
    )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-database-rt"
    }
    
    )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "database" {
  count          = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(
  local.common_tags,
  {
      Name = "${var.project_name}-${var.environment}-nat-eip"
  }
  
  )
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-nat-gw"
    }
    
    )
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0" 
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "database_nat" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}   


