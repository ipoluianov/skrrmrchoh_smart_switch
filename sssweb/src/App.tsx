import React from 'react';
import { DocumentProvider, useDocumentContext } from './DocumentContext';
import Navigator from './Navigator';

import ViewRelays from './ViewRelays';
import ViewSources from './ViewSources';
import ViewSettings from './ViewSettings';
import ViewEEPROM from './ViewEEPROM';

const TabContent: React.FC = () => {
  const { activeTab } = useDocumentContext();

  switch (activeTab) {
    case 'ViewRelays':
      return <ViewRelays />;
    case 'ViewSources':
      return <ViewSources />;
    case 'ViewSettings':
      return <ViewSettings />;
    case 'ViewEEPROM':
      return <ViewEEPROM />;
    default:
      return null;
  }
};

const App: React.FC = () => {
  return (
    <DocumentProvider>
      <div className="App">
        <Navigator />
        <TabContent />
      </div>
    </DocumentProvider>
  );
};

export default App;
