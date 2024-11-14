import React from 'react';
import { useDocumentContext } from './DocumentContext';

const Navigator: React.FC = () => {
  const { activeTab, setActiveTab } = useDocumentContext();

  return (
    <div>
      <button onClick={() => setActiveTab('ViewRelays')}>Реле</button>
      <button onClick={() => setActiveTab('ViewSources')}>Сводка</button>
      <button onClick={() => setActiveTab('ViewSettings')}>Настройки</button>
      <button onClick={() => setActiveTab('ViewEEPROM')}>Образ EEPROM</button>
      <h1>Active Tab: {activeTab}</h1>
    </div>
  );
};

export default Navigator;
