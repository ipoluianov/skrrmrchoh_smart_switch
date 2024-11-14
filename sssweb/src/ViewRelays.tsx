import React from 'react';
import { useDocumentContext } from './DocumentContext';

const ViewRelays: React.FC = () => {
  const { settingsTable } = useDocumentContext();

  // Генерация блоков для реле
  const relayBlocks = Array.from({ length: 16 }, (_, relayIndex) => (
    <React.Fragment key={relayIndex}>
      <tr>
        <td rowSpan={8}>
          <div>
            <strong>{`Реле ${relayIndex + 1}`}</strong>
            <p>Статус: Включено</p> {/* Заглушка для статуса */}
            <button>Вкл.</button>
            <button>Выкл.</button>
          </div>
        </td>
        {Array.from({ length: 13 }).map((_, colIndex) => (
          <td key={`header-col-${colIndex}`}> {/* Заглушка ячеек */}
            {/* Добавим редактируемые ячейки позже */}
          </td>
        ))}
      </tr>
      {Array.from({ length: 7 }, (_, rowIndex) => (
        <tr key={`relay-${relayIndex}-row-${rowIndex}`}>
          {Array.from({ length: 13 }).map((_, colIndex) => (
            <td key={`relay-${relayIndex}-col-${colIndex}`}>
              {/* В будущем здесь будут данные и функционал редактирования */}
            </td>
          ))}
        </tr>
      ))}
    </React.Fragment>
  ));

  return (
    <div style={{ overflowX: 'auto', border: '1px solid #ddd', borderRadius: '4px', width: '100%' }}>
      <table style={{ borderCollapse: 'collapse', width: 'auto' }}>
        <thead style={{ position: 'sticky', top: 0, backgroundColor: '#f9f9f9', zIndex: 1 }}>
          <tr>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Реле</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Включение - Фронт Выключателя</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Включение - Выключатель</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Выключение - Фронт Выключателя</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Выключение - Выключатель</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Включение - Фронт Реле</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Включение - Реле</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Выключение - Фронт Реле</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Выключение - Реле</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Включение по времени - часы</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Включение по времени - минуты</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Выключение по времени - часы</th>
            <th style={{ width: '150px', padding: '8px', borderBottom: '1px solid #ccc' }}>Выключение по времени - минуты</th>
          </tr>
        </thead>
        <tbody>
          {relayBlocks}
        </tbody>
      </table>
    </div>
  );
};

export default ViewRelays;
