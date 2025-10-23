import React from 'react';
import { Typography, Paper } from '@mui/material';

function Products() {
  return (
    <Paper elevation={3} sx={{ p: 4 }}>
      <Typography variant="h4" gutterBottom>
        商品一覧
      </Typography>
      <Typography variant="body1" color="text.secondary">
        商品管理機能は現在開発中です。
      </Typography>
    </Paper>
  );
}

export default Products;
