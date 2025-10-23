import React from 'react';
import { Typography, Paper, Box } from '@mui/material';

function Home() {
  return (
    <Paper elevation={3} sx={{ p: 4 }}>
      <Typography variant="h3" gutterBottom>
        BotSiteSystem へようこそ
      </Typography>
      <Typography variant="h5" color="text.secondary" gutterBottom>
        自動化EC・管理プラットフォーム
      </Typography>
      <Box sx={{ mt: 3 }}>
        <Typography variant="body1" paragraph>
          Django × React × n8n × AWS を用いた、Botによる自動化を組み込んだWebアプリ構築基盤
        </Typography>
        <Typography variant="body1" paragraph>
          個人販売者・小規模事業者のための "自動化EC・管理プラットフォーム"
        </Typography>
        <Typography variant="h6" sx={{ mt: 3, mb: 2 }}>
          主な機能：
        </Typography>
        <Typography variant="body1" component="ul">
          <li>商品管理（EC機能）</li>
          <li>注文管理</li>
          <li>Bot通知による自動化</li>
          <li>API連携</li>
          <li>クラウド運用（AWS）</li>
        </Typography>
      </Box>
    </Paper>
  );
}

export default Home;
